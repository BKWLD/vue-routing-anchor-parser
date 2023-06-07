# Render a nuxt-link if an internal link or a v-parse-anchor wrapped a if not.
# This is so that link pre-fetching works.

import {
	isInternal,
	makeRouterPath,
	shouldOpenInNewWindow,
	addTrailingSlash
} from './index'

export default
	name: 'SmartLink'
	functional: true

	props:
		to: String # The URL gets passed here
		ariaLabel: String # The link accessible label

	# Destructure the props and data we care about
	render: (create, {
		props: { to, ariaLabel }
		data
		listeners
		children
		parent
	}) ->

		# If no "to", wrap children in a span so that children are nested
		# consistently
		if !to then return create 'span', data, children

		# Add trailing slashes if configured to
		if parent?.$config?.anchorParser?.addTrailingSlashToInternal
		then to = addTrailingSlash to

		# Test if an internal link
		if isInternal to

		# Render a nuxt-link
		then create 'nuxt-link', {
			...data
			nativeOn: listeners # nuxt-link doesn't forward events on it's own
			props: to: makeRouterPath to, { router: parent?.$router }
		}, children

		# Make a standard link that opens in a new window
		else create 'a', {
			...data
			attrs: {
				...data.attrs
				href: to
				target: '_blank' if shouldOpenInNewWindow to
				"aria-label": ariaLabel
			}
		}, children
