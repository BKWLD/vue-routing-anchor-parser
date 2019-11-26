/**
 * Nuxt loses the current directory at this point, so I had to refer to the
 * the directive src file through the module name.
 *
 * Also, I can't passthrough objects directly from module.js to here so I'm
 * JSON-ing it and then parsing it back out so I can send arrays through to
 * the directive.
 *
 * Also, custom deserialzing of REGEX
 * https://stackoverflow.com/a/33416684/59160
 */
import Vue from 'vue'
import directive from 'vue-routing-anchor-parser/index.js'
directive.settings(JSON.parse('<%= options %>', function(key, val) {
	if (val.toString().match(/^__REGEX/)) {
    const m = val.split("__REGEX")[1].match(/\/(.*)\/(.*)?/);
    return new RegExp(m[1], m[2] || "");
  }
  return val;
}));
Vue.directive('parse-anchors', directive)
