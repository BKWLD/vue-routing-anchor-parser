# Render a nuxt-link if an internal link or a v-parse-anchor wrapped a if not.
# This is so that link pre-fetching works.

import { isInternal, makeRouterPath, shouldOpenInNewWindow } from './index'

export default
	name: 'SmartLink'
	functional: true

	# The URL gets passed here
	props: to: String

	# Destructure the props and data we care about
	render: (create, {
		props: { to }
		data
		listeners
		children
	}) ->

		# If no "to", wrap children in a span so that children are nested
		# consistently
		if !to then return create 'span', data, children

		# Test if an internal link
		if isInternal to

		# Render a nuxt-link
		then create 'nuxt-link', {
			...data
			nativeOn: listeners # nuxt-link doesn't forward events on it's own
			props: to: makeRouterPath to
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
