should = require 'should'
Err = require '../src/err1st'

describe 'Main', ->

  it 'should return the same stack string as Error', ->
    error = new Error('error')
    err = new Err('error')
    errorStack = error.stack.split('\n')[2..]
    errStack = err.stack.split('\n')[2..]
    errorStack.should.be.eql(errStack)

  it 'should convert original Error object to Err1st object', ->
    error = new Error('Original')
    err = new Err(error)
    err.toString().should.eql("Err1st: Original")
    # err and error should have the same trace stack
    errorStack = error.stack.split('\n')[1..]
    errStack = err.stack.split('\n')[1..]
    errorStack.should.be.eql(errStack)

  it 'should return Err1st object when constuct with Err1st object', ->
    err = new Err('error')
    _err = new Err(err)
    err.stack.should.eql _err.stack

  it 'should parse the phrase to locale message', ->
    # Use the complete meta structure
    Err.meta
      USE_THE_FORCE:
        code: 100  # Custom error code
        status: 400  # Http status code
        _locales:  # Multiple locales
          en:
            message: (name) -> "Use the Force, #{name}"
          zh:
            message: (name) -> "使用原力，#{name}"
    err = new Err('USE_THE_FORCE', 'Luke')
    # Use the first(default) locale
    err.should.have.properties 'stack', 'code', 'status', 'message', 'meta'
    err.message.should.eql "Use the Force, Luke"
    err.code.should.eql 100
    err.status.should.eql 400
    err.toJSON().should.eql
      status: 400
      code: 100
      message: "Use the Force, Luke"

    _err = err.locale('zh')
    _err.should.have.properties 'stack', 'code', 'status', 'message', 'meta'
    _err.message.should.eql "使用原力，Luke"

  it 'should init the meta with short syntax', ->
    Err.meta
      ONLY_EN: [400100, 'only en']
      MULTI_LANG: [400101, {
        en: 'English',
        zh: '中文'
      }]

    err = new Err 'ONLY_EN'
    err.status.should.eql 400
    err.code.should.eql 100
    err.message.should.eql 'only en'

    err = new Err 'MULTI_LANG'
    err.message.should.eql 'English'
    err.locale('zh').message.should.eql '中文'

  it 'should merge the meta when calling the meta method more than once', ->
    Err.meta ERROR: 400100  # Record status and code
    Err.meta
      ERROR:
        _locales:
          en: message: 'something wrong'
          zh: message: '🙅'

    Err._meta.ERROR.should.eql
      status: 400
      code: 100
      _locales:
        en: message: 'something wrong'
        zh: message: '🙅'

    err = new Err 'ERROR'
    err.message.should.eql 'something wrong'
    err.locale('zh').message.should.eql '🙅'

  it 'should direct set the _locales field of each phrase', ->
    Err.localeMeta 'zh',
      HELLO: (name) -> "你好，#{name}!"

    Err.localeMeta 'en',
      HELLO: (name) -> "Hello, #{name}!"

    err = new Err 'HELLO', 'World'
    err.message.should.eql "你好，World!"
    err.locale('en').message.should.eql 'Hello, World!'

    # Merge the other _locale fields
    Err.localeMeta 'zh',
      HELLO:
        code: 333
        status: 401

    err = new Err 'HELLO', 'World'
    err.code.should.eql 333
    err.status.should.eql 401
    err.message.should.eql "你好，World!"

  it 'should mix the params in phrase and get the formated message', ->

    err = new Err 'You have %d unread messages', 3
    err.message.should.eql 'You have 3 unread messages'
