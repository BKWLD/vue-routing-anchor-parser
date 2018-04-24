/**
 * Nuxt loses the current directory at this point, so I had to refer to the
 * the directive src file through the module name.
 *
 * Also, I can't passthrough objects directly from module.js to here so I'm
 * JSON-ing it and then parsing it back out so I can send arrays through to
 * the directive.
 */
const Vue = require('vue')
const directive = require('vue-routing-anchor-parser/index.coffee')
directive.settings(JSON.parse('<%= options %>'));
Vue.directive('parse-anchors', directive)
