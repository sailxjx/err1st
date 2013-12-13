path = require('path')
Err = require('./err1st')

class Handler

  mapReflect = ['code', 'msg']

  constructor: ->
    @_map = {}
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
          return @_map

    @map =
      defaultError: [500100, 'Unknown Error']

  validate: (fn) ->
    fn.call(this, this) if typeof fn is 'function'

  parse: (err, options = {}) ->
    err = new Err(err) if typeof err is 'string'

    unless err instanceof Err and @map[err.toPhrase()]
      _oriPhrase = err.toPhrase()
      err = new Err('defaultError')

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
    unless @_i18n?
      _i18n = {}
      for i, _lang of @locales
        try
          _i18n[_lang] = require(path.join(@localeDir, _lang))
        catch e
          _i18n[_lang] = {}
      @_i18n = _i18n

    if lang? and phrase?
      return @_i18n?[lang]?[phrase]
    else
      return @_i18n

handler = new Handler
handler.Handler = Handler
module.exports = handler
