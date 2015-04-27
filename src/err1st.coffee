util = require 'util'

_parseMeta = (meta) ->
  if toString.call(meta) is '[object Object]'
    _meta = meta

  else if /^-?[0-9]+$/.test meta
    status = Number(String(meta)[0...3])
    code = Number(String(meta)[3...])
    _meta = status: status, code: code

  else if toString.call(meta) is '[object String]'
    _meta = message: meta

  else if toString.call(meta) is '[object Array]'
    _meta = meta.reduce (meta, cur) ->
      _cur = _parseMeta(cur)
      meta[key] = val for key, val of _cur
      meta
    , {}

  else _meta = {}

  _meta

class Err1st extends Error

  name: 'Err1st'

  @_meta: {}

  constructor: (args...) ->
    Error.captureStackTrace(this, arguments.callee)
    [phrase, params...] = args
    @phrase = phrase
    @params = params

    if phrase instanceof Err1st
      return
    else if phrase instanceof Error
      @message = phrase.message or 'Unknown Error'
      @phrase = phrase.name or 'Error'
      @code = phrase.code or 100
      @status = phrase.status or 500
    else
      _meta = @constructor._meta[phrase] or
        status: 500
        code: 100
        message: 'Unknown Error'

      Object.defineProperty this, 'meta',
        get: ->
          return _meta unless _meta._locales
          # Use the first key as default language
          @_lang or= Object.keys(_meta._locales)[0]
          _meta = util._extend _meta, _meta._locales[@_lang]
          _meta
      Object.defineProperty this, 'code', get: -> @meta.code
      Object.defineProperty this, 'status', get: -> @meta.status
      Object.defineProperty this, 'message', get: ->
        if toString.call(@meta.message) is '[object Function]'
          @meta.message.apply this, @params
        else
          @meta.message

  toJSON: ->
    status: @status
    code: @code
    message: @message

  locale: (@_lang) -> this

  @meta: (meta) ->
    for phrase, _meta of meta
      @_meta[phrase] or= {}
      _meta = _parseMeta _meta
      for key, val of _meta
        if key is '_locales'
          @_meta[phrase]
        @_meta[phrase][key] = val
    @_meta

module.exports = Err1st
