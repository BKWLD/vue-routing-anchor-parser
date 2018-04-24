# vue-routing-anchor-parser
A Vue directive that parses itself and children for anchor tags and binds clicks to use Vue Router's push rather if they link internally


## Notes

- This currently only parses children, not the element the directive is added to
- This currently only parses on `bind`, meaning if the contents for the element change later, new `a` tags won't be processed.
