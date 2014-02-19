path = require('path')
Err = require('./err1st')
util = require('util')

class Handler

  mapReflect = ['code', 'msg']

  constructor: ->
    @_map = {}
    @_code = {}
    @_i18n = {}
    @locales = ['en']
    @localeDir = "#{process.cwd()}/locales"
    @name = null

    Object.defineProperties this,
      map:
        get: -> @_map
        set: (map) ->
          for k, v of map
            if v instanceof Array
              @_map[k] = {}
              for i, _v of mapReflect
                @_map[k][_v] = v[i]
            else if typeof v is 'number'
              @_map[k] = {code: v}
            else
              @_map[k] = v
            @_code[Number(String(@_map[k].code)[3..])] = k if @_map[k].code?
          return @_map

    @map = defaultError: [500100, 'Unknown Error']

  validate: (fn) ->
    fn.call(this, this) if typeof fn is 'function'
    @_initI18n()
    return this

  _initI18n: ->
    return false unless @localeDir
    for i, lang of @locales
      try
        @_i18n[lang] = {} unless @_i18n[lang]?
        newI18n = require(path.join(@localeDir, lang))
        @_i18n[lang] = util._extend(@_i18n[lang], newI18n)
      catch e
    return @_i18n

  # Restore Error from code
  restore: (code) -> return new Err(@_code[Number(code)])

  parse: (err, options = {}) ->
    err = new Err(err) if typeof err is 'string'

    unless err instanceof Err and @map[err.toPhrase()]
      _oriPhrase = err.toPhrase?() or 'defaultError'
      err = new Err('defaultError')

    return err unless err instanceof Err

    _phrase = err.toPhrase()
    _map = @map[_phrase]
    err.code = _map.code
    lang = options.lang or @locales[0]

    if _oriPhrase?
      msg = @i18n(lang, _oriPhrase) or _map.msg
    else
      msg = _map.msg or @i18n(lang, _phrase)

    err.name = @name if @name?

    if typeof msg is 'function'
      err.message = msg.apply(err, err.msgData)
    else
      err.message = msg

    return err

  i18n: (lang, phrase) ->
    if lang? and phrase?
      return @_i18n?[lang]?[phrase]
    else
      return @_i18n

handler = new Handler
handler.Handler = Handler
module.exports = handler
