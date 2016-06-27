Err1st
======

Custom `Error` object

[![NPM version][npm-image]][npm-url] [![Build Status][travis-image]][travis-url]

We hate errors, but we can not live without them.

# Example

Use err1st as an standard error object

```coffeescript
Err = require 'err1st'
err = new Err('SOMETHING_WRONG')
throw err
```

Customize the error message

```coffeescript
Err.meta
  SOMETHING_WRONG:
    status: 400
    code: 100
    message: (name) -> "something wrong, #{name}"

err = new Err 'SOMETHING_WRONG', 'Alice'
throw err  ==>  Err1st: "something wrong, Alice" ....

# With i18n locales
Err.localeMeta 'emoji',
  SOMETHING_WRONG: (name) -> "🙅, #{name}"
  ...

Err.localeMeta 'en',
  SOMETHING_WRONG: (name) -> "something wrong, #{name}"

err = new Err 'SOMETHING_WRONG', 'Bob'
console.log err.message  ==>  "🙅, Bob"
console.log err.locale('en').message  ==>  "something wrong, #{name}"
```

Combine meta and locales together

```coffeescript
Err.meta
  completed:
    status: 400
    code: 100
    locales:
      en: 'English'
      zh: '中文'
  flatten: [400100, {  # Treat keys of object as language, except 'code', 'status', 'locales'
    en: 'English',
    zh: '中文'
  }]
  useFunction: [400100, {
    en: -> 'English'
    zh: -> '中文'
  }]
```

# ChangeLog

## 0.2.6
- Support auto detect locale keys when use `meta` function

## 0.2.0
* Remove handler, parse the messages by the Err object itself.

## 0.1.3
* keep the status and code of original error object

## 0.1.2
* use 'DNA' to identify the same error instance

## 0.1.1
* err.code is equal to err.toCode() now
* handler.validate now support directly set a i18n dict.

# Licence
MIT

[npm-url]: https://npmjs.org/package/err1st
[npm-image]: http://img.shields.io/npm/v/err1st.svg

[travis-url]: https://travis-ci.org/sailxjx/err1st
[travis-image]: http://img.shields.io/travis/sailxjx/err1st.svg
