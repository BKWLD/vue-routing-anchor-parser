'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.shouldOpenInNewWindow = exports.makeRouterPath = exports.isInternal = exports.handleAnchor = undefined;

var _urlParse = require('url-parse');

var _urlParse2 = _interopRequireDefault(_urlParse);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

// Generated by CoffeeScript 2.2.4
// Deps
var bind,
    handleExternal,
    handleInternal,
    makeUrlObj,
    mergeSettings,
    settings,
    _extends = Object.assign || function (target) {
  for (var i = 1; i < arguments.length; i++) {
    var source = arguments[i];for (var key in source) {
      if (Object.prototype.hasOwnProperty.call(source, key)) {
        target[key] = source[key];
      }
    }
  }return target;
},
    indexOf = [].indexOf;

// Default settings
settings = {
  addBlankToExternal: false,
  internalUrls: [],
  sameWindowUrls: [],
  internalHosts: []
};

// Override the settings
mergeSettings = function mergeSettings(choices) {
  return settings = _extends({}, settings, choices);
};

// Add listeners to anchors
bind = function bind(el, binding, vnode) {
  var anchor, i, len, ref, results, router;
  // Get the router instance
  router = vnode.context.$router;
  if (el.tagName.toLowerCase() === 'a') {
    // Handle self
    handleAnchor(el, router);
  }
  ref = el.querySelectorAll('a');
  results = [];
  for (i = 0, len = ref.length; i < len; i++) {
    anchor = ref[i];
    // Handle child anchors that have an href
    results.push(handleAnchor(anchor, router));
  }
  return results;
};

// Check an anchor tag
var handleAnchor = exports.handleAnchor = function handleAnchor(anchor, router) {
  var url;
  if (url = anchor.getAttribute('href')) {
    if (isInternal(url)) {
      return handleInternal(anchor, url, router);
    } else {
      return handleExternal(anchor, url);
    }
  }
};

// Test if an anchor is an internal link
var isInternal = exports.isInternal = function isInternal(url) {
  var i, len, ref, ref1, urlObj, urlRegex;
  urlObj = makeUrlObj(url);
  if (urlObj.href.match(/^\/[^\/]/)) {
    // Does it begin with a / and not an //
    return true;
  }
  ref = settings.internalUrls;
  // Does the hot match internal URLs
  for (i = 0, len = ref.length; i < len; i++) {
    urlRegex = ref[i];
    if (urlObj.href.match(urlRegex)) {
      return true;
    }
  }
  if (ref1 = urlObj.host, indexOf.call(settings.internalHosts, ref1) >= 0) {
    // Does the host match internal hosts
    return true;
  }
};

// Make a URL instance from url strings
makeUrlObj = function makeUrlObj(url) {
  if (typeof url !== 'string') {
    // Already a URL object
    return url;
  }
  if (url.match(/^#/)) {
    // If the URL is just an anchor, prepend the current path so that the URL obj
    // doesn't add an automatic root path
    url = (typeof window !== "undefined" && window !== null ? window.location.pathname : void 0) + url;
  }
  // Return URL object
  return new _urlParse2.default(url);
};

// Add click bindings to internal links that resolve.  Thus, if the Vue doesn't
// know about a route, it will not be handled by vue-router.  Though it won't
// open in a new window.
handleInternal = function handleInternal(anchor, url, router) {
  var path;
  path = makeRouterPath(url);
  if (router.resolve({ path: path }).route.matched.length) {
    return anchor.addEventListener('click', function (e) {
      e.preventDefault();
      return router.push({ path: path });
    });
  }
};

// Make routeable path
var makeRouterPath = exports.makeRouterPath = function makeRouterPath(url) {
  var urlObj;
  urlObj = makeUrlObj(url);
  return '' + urlObj.pathname + urlObj.query + urlObj.hash;
};

// Add target blank to external links
handleExternal = function handleExternal(anchor, url) {
  if (shouldOpenInNewWindow(url) && !anchor.hasAttribute('target')) {
    return anchor.setAttribute('target', '_blank');
  }
};

// Should extrnal link open in a new window
var shouldOpenInNewWindow = exports.shouldOpenInNewWindow = function shouldOpenInNewWindow(url) {
  var i, len, ref, urlObj, urlRegex;
  if (!settings.addBlankToExternal) {
    return false;
  }
  urlObj = makeUrlObj(url);
  if (urlObj.href.match(/^javascript:/)) {
    // A javascript:func() link
    return false;
  }
  ref = settings.sameWindowUrls;
  for (i = 0, len = ref.length; i < len; i++) {
    urlRegex = ref[i];
    if (urlObj.href.match(urlRegex)) {
      return false;
    }
  }
  return true;
};

exports.default = {
  // Directive definition with settings method for overriding the default settings.
  // I'm relying on Browser garbage collection to cleanup listeners.
  bind: bind,
  settings: mergeSettings
};