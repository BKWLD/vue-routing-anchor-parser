# Default settings
settings =
	addBlankToExternal: true
	internalHosts: [ location?.host ]

# Deps
URL = require 'url-parse'

# Add listeners to anchors
bind = (el, binding, vnode) ->

	# Get the router instance
	router = vnode.context.$router

	# Get anchors that have an href
	el.querySelectorAll('a').forEach (anchor) ->
		return unless href = anchor.getAttribute 'href'
		url = new URL href
		if isInternal url
		then handleInternal anchor, url, router
		else handleExternal anchor

# Test if an anchor is an internal link
isInternal = (url) ->

	# Does it begin with a / and not an //
	return true if url.href.match /^\/[^\/]/

	# Does the host match the comparer
	return true if url.host in settings.internalHosts

# Add click bindings to internal links that resolve.  Thus, if the Vue doesn't
# know about a route, it will not be handled by vue-router.  Though it won't
# open in a new window.
handleInternal = (anchor, url, router) ->
	route = path: "#{url.pathname}#{url.query}"
	if router.resolve(route).route.matched.length
		anchor.addEventListener 'click', (e) ->
			e.preventDefault()
			router.push path: "#{url.pathname}#{url.query}"

# Add target blank to external links
handleExternal = (anchor) ->
	if settings.addBlankToExternal and not anchor.hasAttribute('target')
		anchor.setAttribute 'target', '_blank'

# Directive definition.  Relying on Browser garbage collection to cleanup
# listeners
module.exports =
	bind: bind
