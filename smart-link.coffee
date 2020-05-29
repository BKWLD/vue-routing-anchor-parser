# Render a nuxt-link if an internal link or a v-parse-anchor wrapped a if not. 
# This is so that link pre-fetching works.

import { isInternal, makeRouterPath, shouldOpenInNewWindow } from './index'

export default 
	name: 'SmartLink'
	functional: true

	# Destructure the props and data we care about
	render: (create, { 
		props: { to }, 
		data: { attrs, staticClass } 
		children
	}) -> 

		# If no "to", just return children
		return children unless to

		# Test if an internal link
		if isInternal to

		# Render a nuxt-link
		then create 'nuxt-link',
			props: to: makeRouterPath to
			attrs: attrs
			class: staticClass
		, children
		
		# Make a standard link that opens in a new window
		else create 'a', 
			attrs: 
				href: to
				target: '_blank' if shouldOpenInNewWindow to
			class: staticClass
		, children
