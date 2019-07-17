# Deps
import URL from 'url-parse'
import merge from 'lodash/merge'

# Default settings
settings =
	addBlankToExternal: false
	internalHosts: [ location?.host ]

# Override the settings
mergeSettings = (choices) -> merge settings, choices

# Add listeners to anchors
bind = (el, binding, vnode) ->

	# Get the router instance
	router = vnode.context.$router

	# Handle self
	handleAnchor el, router if el.tagName.toLowerCase() == 'a'

	# Handle child anchors that have an href
	handleAnchor anchor, router for anchor in el.querySelectorAll 'a'

# Check an anchor tag
export handleAnchor = (anchor, router) ->
	if href = anchor.getAttribute 'href'
		url = makeUrlObj href
		if isInternal url
		then handleInternal anchor, url, router
		else handleExternal anchor

# Test if an anchor is an internal link
export isInternal = (url) ->
	url = makeUrlObj url

	# Does it begin with a / and not an //
	return true if url.href.match /^\/[^\/]/

	# Does the host match the comparer
	return true if url.host in settings.internalHosts

# Make a URL instance from url strings
makeUrlObj = (url) ->
	
	# Already a URL object
	return url unless typeof url == 'string' 
	
	# If the URL is just an anchor, prepend the current path so that the URL obj
	# doesn't add an automatic root path
	url = window?.location.pathname + url if url.match /^#/ 
	
	# Return URL object
	return new URL url

# Add click bindings to internal links that resolve.  Thus, if the Vue doesn't
# know about a route, it will not be handled by vue-router.  Though it won't
# open in a new window.
handleInternal = (anchor, url, router) ->
	route = path: "#{url.pathname}#{url.query}"
	if router.resolve(route).route.matched.length
		anchor.addEventListener 'click', (e) ->
			e.preventDefault()
			router.push path: "#{url.pathname}#{url.query}#{url.hash}"

# Add target blank to external links
handleExternal = (anchor) ->
	if settings.addBlankToExternal and not anchor.hasAttribute('target')
		anchor.setAttribute 'target', '_blank'

# Directive definition with settings method for overriding the default settings.
# I'm relying on Browser garbage collection to cleanup listeners.
export default
	bind: bind
	settings: mergeSettings
