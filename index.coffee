# Deps
import URL from 'url-parse'

# Default settings
settings =
	addBlankToExternal: false
	internalUrls: []
	sameWindowUrls: []
	internalHosts: []
	externalPaths: []

# Override the settings
mergeSettings = (choices) -> settings = {...settings, ...choices }

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

	# If an explicit target attribute is set, then abort.  Assuming the author
	# of the content knew what they were doing.
	return if anchor.getAttribute 'target'

	if url = anchor.getAttribute 'href'
		if isInternal url
		then handleInternal anchor, url, router
		else handleExternal anchor, url

# Test if an anchor is an internal link
export isInternal = (url) ->
	urlObj = makeUrlObj url

	# Does it match externalPaths
	for pathRegex in settings.externalPaths
		return false if urlObj.pathname.match pathRegex

	# Does it begin with a / and not an //
	return true if urlObj.href.match /^\/(?!\/)/

	# Does the host match internal URLs
	for urlRegex in settings.internalUrls
		return true if urlObj.href.match urlRegex

	# Does the host match internal hosts
	return true if urlObj.host in settings.internalHosts

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
	path = makeRouterPath url
	if router.resolve({ path }).route.matched.length
		anchor.addEventListener 'click', (e) ->
			e.preventDefault()
			router.push { path }

# Make routeable path
export makeRouterPath = (url) ->
	urlObj = makeUrlObj url
	"#{urlObj.pathname}#{urlObj.query}#{urlObj.hash}"

# Add target blank to external links
handleExternal = (anchor, url) ->
	if shouldOpenInNewWindow(url) and not anchor.hasAttribute('target')
		anchor.setAttribute 'target', '_blank'

# Should extrnal link open in a new window
export shouldOpenInNewWindow = (url) ->
	return false unless settings.addBlankToExternal
	urlObj = makeUrlObj url
	return false if urlObj.href.match /^javascript:/ # A javascript:func() link
	for urlRegex in settings.sameWindowUrls
		return false if urlObj.href.match urlRegex
	return true

# Directive definition with settings method for overriding the default settings.
# I'm relying on Browser garbage collection to cleanup listeners.
export default
	bind: bind
	settings: mergeSettings
