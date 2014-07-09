err1st [![NPM version][npm-image]][npm-url] [![Build Status][travis-image]][travis-url]
======

Custom `error` object

We hate errors, but we can not live without them.

# Example

Use err1st as an standard error object

```coffee-script
Err = require 'err1st'
err = new Err('SOMETHING_WRONG')
throw err
```

Customize the error message and add i18n support
```coffee-script
Err = require 'err1st'
{handler} = Err
err = new Err('SOMETHING_WRONG', 'Alice')

handler.validate ->
  @localeDir = __dirname  # Set you path to i18n configration files, these file should be named by language, e.g. 'en.json', 'zh.js'
  @locales = ['en', 'zh']  # Set supported languages, first is the default one
  @map = SOMETHING_WRONG: 500100  # Set your error code map

throw handler.parse err
throw handler.parse err, lang: 'zh'
```

# Output
```
Err1st: Alice, you've got something wrong
  at Object.<anonymous> (/Users/tristan/coding/err1st/examples/index.coffee:3:11)
  at Object.<anonymous> (/Users/tristan/coding/err1st/examples/index.coffee:1:1)
  at Module._compile (module.js:456:26)

> or

Err1st: Alice, 你犯了个错误
  at Object.<anonymous> (/Users/tristan/coding/err1st/examples/index.coffee:3:11)
  at Object.<anonymous> (/Users/tristan/coding/err1st/examples/index.coffee:1:1)
  at Module._compile (module.js:456:26)
```

# ChangeLog

## v0.1.1
* err.code is equal to err.toCode() now
* handler.validate now support directly set a i18n dict.

# Licence
MIT

[npm-url]: https://npmjs.org/package/err1st
[npm-image]: http://img.shields.io/npm/v/err1st.svg

[travis-url]: https://travis-ci.org/sailxjx/err1st
[travis-image]: http://img.shields.io/travis/sailxjx/err1st.svg
