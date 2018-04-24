/**
 * Nuxt loses the current directory at this point, so I had to refer to the
 * the directive src file through the module name.
 */
const Vue = require('vue')
const directive = require('vue-routing-anchor-parser/index.coffee')
Vue.directive('parse-anchors', directive)
