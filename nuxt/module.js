/**
 * Register the directive
 */
const path = require('path')
module.exports = function () {
	this.addPlugin({
		src: path.resolve(__dirname, 'plugin.js')
	});
}

// Export meta for Nuxt
module.exports.meta = require('../package.json')
