err1st
======

Custom `error` object in error-first callbacks

[![build status](https://api.travis-ci.org/sailxjx/err1st.png)](https://travis-ci.org/sailxjx/err1st)

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
  @localeDir = __dirname  # Set you path to i18n configration files
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
