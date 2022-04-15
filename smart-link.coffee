# Render a nuxt-link if an internal link or a v-parse-anchor wrapped a if not.
# This is so that link pre-fetching works.

import { isInternal, makeRouterPath, shouldOpenInNewWindow, addTrailingSlash } from './index'

export default
	name: 'SmartLink'
	functional: true

	props:
		to: String # The URL gets passed here
		internalTrailingSlash: Boolean # Optionally add trailing slash if is internal link

	# Destructure the props and data we care about
	render: (create, {
		# props: { to, internalTrailingSlash }
		props
		data
		listeners
		children
	}) ->
		to = props.to
		internalTrailingSlash = props.internalTrailingSlash
		console.log 'rendering link, to is', to, 'internaltrailingslash is', internalTrailingSlash, 'props are', props

		# If no "to", wrap children in a span so that children are nested
		# consistently
		if !to then return create 'span', data, children

		# Test if an internal link
		if isInternal to

		# Render a nuxt-link
		then create 'nuxt-link', {
			...data
			nativeOn: listeners # nuxt-link doesn't forward events on it's own
			props: 
				to: if internalTrailingSlash 
				then makeRouterPath addTrailingSlash to 
				else makeRouterPath to
		}, children

		# Make a standard link that opens in a new window
		else create 'a', {
			...data
			attrs: {
				...data.attrs
				href: to
				target: '_blank' if shouldOpenInNewWindow to
			}
		}, children
