# Use Cloak to make boilerplate
{ mergeConfig, makeBoilerplate, isDev, isGenerating } = require '@bkwld/cloak'
boilerplate = makeBoilerplate
	siteName: 'vue-routing-anchor-parser-demo'
	cms: '@nuxt/content'

# Don't add vue-routing-anchor-parser from package
boilerplate.modules = boilerplate.modules.filter (module) ->
	module != 'vue-routing-anchor-parser/nuxt/module'

# Nuxt config
module.exports = mergeConfig boilerplate,

	modules: [
		'@nuxt/content'
	]

	plugins: [
		'plugins/use-local-package'
	]

	# Enable crawler to find dynamic pages
	generate:
		crawler: true
		routes: -> ['/']

	# Add production internal URL
	anchorParser: internalUrls: [
		# /^https?:\/\/(www\.)?domain\.com/
	]

	# Nuxt content configuration
	content:
		liveEdit: false
		markdown: prism: theme: 'prism-themes/themes/prism-atom-dark.css'
