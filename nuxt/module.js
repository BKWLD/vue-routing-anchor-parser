/**
 * Register the directive
 */
const path = require('path')
module.exports = function (options) {

	// Accept options from module or config
	options = {...options, ...this.options.anchorParser}

	// Register a plugin that applys the settings for SSR and non-SSR
	this.addPlugin({
		src: path.resolve(__dirname, 'settings.js'),

		// Serialize Regexes. I found I needed to manually double escape
		// backslashes for this to work.
		// https://stackoverflow.com/a/33416684/59160
		options: JSON.stringify(options, function(key,  val) {
			return val instanceof RegExp ?
				'__REGEX' + val.toString().replace(/\\/g, '\\\\') : val;
		}),
	})

	// Register the actual directive on client side only
	this.addPlugin({
		src: path.resolve(__dirname, 'directive.js'),
		ssr: false,
	});
}

// Export meta for Nuxt
module.exports.meta = require('../package.json')
