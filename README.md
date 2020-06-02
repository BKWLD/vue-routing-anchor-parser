# vue-routing-anchor-parser

A Vue directive that parses child elements for internally linking anchor tags and binds their click events to use Vue Router's push().

## Install

`yarn add vue-routing-anchor-parser` or `npm install --save vue-routing-anchor-parser`

## Configure

#### Vue

In a your bootstrapping JS:

```js
parseAnchors = require('vue-routing-anchor-parser')
directive.settings({
  addBlankToExternal: false,
  internalUrls: [
    /^https?:\/\/localhost:\d+/
    /^https?:\/\/([\w\-]+\.)?netlify\.com/
    /^https?:\/\/([\w\-]+\.)?bukwild\.com/
  ]
  internalHosts: [
    'localhost',
    'example.com',
  ]
})
Vue.directive('parse-anchors', parseAnchors)
```

#### Nuxt

In `nuxt.config.js`:

```js
  modules: [
    'vue-routing-anchor-parser/nuxt/module',
  ],
  anchorParser: {
    addBlankToExternal: true,
    internalUrls: [
      /^https?:\/\/localhost:\d+/
      /^https?:\/\/([\w\-]+\.)?netlify\.com/
      /^https?:\/\/(www\.)?bukwild\.com/
    ]
    internalHosts: [
      'localhost',
      'bukwild.com',
    ]
    sameWindowUrls: [
      /^https?:\/\/(shop\.)?bukwild\.com/
    ]
  }
```

#### Options

- `addBlankToExternal`: Set to true to add `target='_blank'` to external links
- `internalUrls`: Array of regexes that, when found in `href` attributes, get treated as internal links.
- `internalHosts`: Array of host names that, when found in `href` attributes, get treated as internal links.  These are checked after `internalUrls`.
- `sameWindowUrls`: Array of regexes that are checked when a URL is not internal. If there is a match, the URL opens in the same window rather opening a new window.

## Usage

Add `v-parse-anchors` wherever you want to parse child anchors for internal links and route clicks through Vue Router.  `href`s that begin with a slash, like `<a href='/path/to/something'>` are treated as internal automatically.  If an internal route can't be resolved by Vue Router, it falls back to a full page refresh (though never opens in a new window.)

#### `smart-link`

The `smart-link` component conditionally renders a `nuxt-link` if an internal link or an `a` tag if not. It's not registered by default by the Nuxt module.

```js
import SmartLink from 'vue-routing-anchor-parser/smart-link`
Vue.component('smart-link', SmartLink)
```
```html
<smart-link to='https://www.bukwild.com'>Bukwild</smart-link>
```

## Notes

- This currently only parses on `bind`, meaning if the contents for the element change later, new `a` tags won't be processed.
