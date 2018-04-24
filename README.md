# vue-routing-anchor-parser

A Vue directive that parses child elements for internally linking anchor tags and binds their click events to use Vue Router's push().

## Install

`yarn add vue-routing-anchor-parser` or `npm install --save vue-routing-anchor-parser`

## Configure

#### Vue

In a your bootstrapping JS:

```js
parseAnchors = require('vue-routing-anchor-parser/index.coffee')
directive.settings({
  addBlankToExternal: false
  internalHosts: [
     'localhost'
    'example.com'
  ]
})
Vue.directive('parse-anchors', parseAnchors)
```

#### Nuxt

In `nuxt.config.js`:

```js
  modules: [
    ['vue-routing-anchor-parser/nuxt/module', {
        addBlankToExternal: true
        internalHosts: [
          'localhost'
          'example.com'
        ]
    }]
  ]
```

#### Options

- `addBlankToExternal`: Set to true to add `target='_blank'` to external links
- `internalHosts`: Array of host names that, when found in `href` attributes, get treated as internal links

## Usage

Add `v-parse-anchors` wherever you want to parse child anchors for internal links and route clicks through Vue Router.  `href`s that begin with a slash, like `<a href='/path/to/something'>` are treated as internal automatically.  If an internal route can't be resolved by Vue Router, it falls back to a full page refresh (though never opens in a new window.)

## Notes

- This currently only parses children, not the element the directive is added to
- This currently only parses on `bind`, meaning if the contents for the element change later, new `a` tags won't be processed.
