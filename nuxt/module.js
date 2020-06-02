/**
 * Register the directive
 */
const path = require('path')
module.exports = function (options) {

	// Accept options from module or config
	options = {...options, ...this.options.anchorParser}
		
	// Register the plugin
	this.addPlugin({
		src: path.resolve(__dirname, 'plugin.js'),
		ssr: false,
		
		// Serialize Regexes. I found I needed to manually double escape
		// backslashes for this to work.
		// https://stackoverflow.com/a/33416684/59160
		options: JSON.stringify(options, function(key,  val) { 
			return val instanceof RegExp ? 
				'__REGEX' + val.toString().replace(/\\/g, '\\\\') : val;
		}),
	});
}

// Export meta for Nuxt
module.exports.meta = require('../package.json')
