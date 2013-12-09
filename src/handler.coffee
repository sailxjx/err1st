path = require('path')
Err = require('./err1st')

class Handler

  mapReflect = ['code', 'msg']

  constructor: ->
    @_map = {}
    @locales = ['en']
    @localeDir = "#{process.cwd()}/locales"

    Object.defineProperties this,
      map:
        get: -> @_map
        set: (map) ->
          for k, v of map
            if v instanceof Array
              @_map[k] = {}
              for i, _v of mapReflect
                @_map[k][_v] = v[i]
            else
              @_map[k] = v
          return @_map

  validate: (fn) ->
    fn.call(this, this) if typeof fn is 'function'

  parse: (err, options = {}) ->
    return err unless err instanceof Err and @map[err.toPhrase()]

    _phrase = err.toPhrase()
    _map = @map[_phrase]
    err.code = _map.code
    lang = options.lang or @locales[0]
    msg = _map.msg or @i18n()[lang]?[_phrase]

    if typeof msg is 'function'
      err.message = msg.apply(err, err.msgData)
    else
      err.message = msg

    return err

  i18n: ->
    unless @_i18n?
      _i18n = {}
      for i, lang of @locales
        try
          _i18n[lang] = require(path.join(@localeDir, lang))
        catch e
          _i18n[lang] = {}
      @_i18n = _i18n
    return @_i18n

handler = new Handler
handler.Handler = Handler
module.exports = handler
