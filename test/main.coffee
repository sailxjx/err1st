should = require 'should'
Err = require '../src/err1st'

describe 'Main', ->

  _compareStack = (err, error) ->
    stackErrors = error.stack.split('\n')[2..]
    stackErrs = err.stack.split('\n')[2..]
    stackErrs.should.be.eql(stackErrors)

  it 'should return the same stack string as Error', ->
    error = new Error('error')
    err = new Err('error')
    _compareStack(err, error)

  it 'should convert original Error object to Err1st object', ->
    error = new Error('Original')
    err = new Err(error)
    err.toString().should.eql("Err1st: Original")
    _compareStack(err, error)

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
      SHORT_ERROR: [400100, 'short message']

    err = new Err 'SHORT_ERROR'
    err.status.should.eql 400
    err.code.should.eql 100
    err.message.should.eql 'short message'

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
