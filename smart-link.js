'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _index = require('./index');

// Generated by CoffeeScript 2.2.4
// Render a nuxt-link if an internal link or a v-parse-anchor wrapped a if not.
// This is so that link pre-fetching works.
var _extends = Object.assign || function (target) {
  for (var i = 1; i < arguments.length; i++) {
    var source = arguments[i];for (var key in source) {
      if (Object.prototype.hasOwnProperty.call(source, key)) {
        target[key] = source[key];
      }
    }
  }return target;
};

exports.default = {
  name: 'SmartLink',
  functional: true,
  props: {
    to: String // The URL gets passed here
  },

  // Destructure the props and data we care about
  render: function render(create, _ref) {
    var to = _ref.props.to,
        data = _ref.data,
        listeners = _ref.listeners,
        children = _ref.children,
        parent = _ref.parent;

    var ref, ref1;
    if (!to) {
      return create('span', data, children);
    }
    // Add trailing slashes if configured to
    if (parent != null ? (ref = parent.$config) != null ? (ref1 = ref.anchorParser) != null ? ref1.addTrailingSlashToInternal : void 0 : void 0 : void 0) {
      to = (0, _index.addTrailingSlash)(to);
    }
    // Test if an internal link
    if ((0, _index.isInternal)(to)) {
      // Render a nuxt-link
      return create('nuxt-link', _extends({}, data, {
        nativeOn: listeners, // nuxt-link doesn't forward events on it's own
        props: {
          to: (0, _index.makeRouterPath)(to, {
            router: parent != null ? parent.$router : void 0
          })
        }
      }), children);
    } else {
      // Make a standard link that opens in a new window
      return create('a', _extends({}, data, {
        attrs: _extends({}, data.attrs, {
          href: to,
          target: (0, _index.shouldOpenInNewWindow)(to) ? '_blank' : void 0
        })
      }), children);
    }
  }
};