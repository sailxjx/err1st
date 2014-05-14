path = require('path')
Err = require('./err1st')
util = require('util')

class Handler

  mapReflect = ['code', 'msg']

  constructor: ->
    @_map = {}
    @_codes = {}
    @locales = ['en']
    @localeDir = "#{process.cwd()}/locales"

    Object.defineProperties this,
      map:
        get: -> @_map
        set: (map) ->
          for k, v of map
            k = k.toUpperCase()
            if v instanceof Array
              @_map[k] = {}
              for i, _v of mapReflect
                @_map[k][_v] = v[i]
            else if typeof v is 'number'
              @_map[k] = {code: v}
            else
              @_map[k] = v
            # Save codes in the hash to restore error object from code
            @_codes[Number(String(@_map[k].code)[3..])] = k if @_map[k].code?
          return @_map

    @map = DEFAULT_ERROR: [500100, 'unknown error']

  validate: (fn) ->
    fn.call(this, this) if typeof fn is 'function'
    @_loadI18n()
    return this

  _loadI18n: ->
    return false unless @localeDir

    i18n = {}

    for i, lang of @locales
      try
        i18n[lang] = require(path.join(@localeDir, lang))
      catch e

    for lang, msgMap of i18n
      for k, msg of msgMap
        k = k.toUpperCase()
        @_map[k] = {} unless @_map[k]
        @_map[k]["msg_#{lang}"] = msg

    return this

  # Restore Error from code
  restore: (code) -> return new Err(@_codes[Number(code)])

  parse: (err, options = {}) ->
    # ---------------- Ensure return an err1st object ----------------
    if typeof err is 'string'  # Only error phrase
      err = new Err(err)

    unless err instanceof Err
      if err instanceof Error  # The origin error object
        err = new Err(err)
      else
        err = new Err('DEFAULT_ERROR')
    # ---------------- Ensure return an err1st object ----------------

    _phrase = err.toPhrase()?.toUpperCase()
    _map = @map[_phrase]

    unless _map  # No map error object will remain its own message and a default code
      err.code or= @map['DEFAULT_ERROR'].code
      return err

    err.name = @name if @name
    err.code = _map.code or @map['DEFAULT_ERROR'].code
    lang = options.lang or @locales[0]
    msg = _map["msg_#{lang}"] or _map['msg']

    if typeof msg is 'function'
      err.message = msg.apply(err, err.msgData)
    else if typeof msg is 'string'
      err.message = msg

    return err

handler = new Handler
handler.Handler = Handler
module.exports = handler
