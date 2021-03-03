/**
 * Nuxt loses the current directory at this point, so I had to refer to the
 * the directive src file through the module name.
 */
import Vue from 'vue'
import SmartLink from 'vue-routing-anchor-parser/smart-link.js'
Vue.component('smart-link', SmartLink)
