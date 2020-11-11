/**
 * Nuxt loses the current directory at this point, so I had to refer to the
 * the directive src file through the module name.
 */
import Vue from 'vue'
import directive from 'vue-routing-anchor-parser/index.js'
Vue.directive('parse-anchors', directive)
