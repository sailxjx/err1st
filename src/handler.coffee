class Handler

  constructor: ->
    @_codes =
      succ: 200000
      error: 500900
    @_msgs =
      succ: 'Success'
      error: 'Error'

    Object.defineProperties this,
      codes:
        get: -> @_codes
        set: (codes) -> @_codes[k] = v for k, v of codes
      msgs:
        get: -> @_msgs
        set: (msgs) -> @_msgs[k] = v for k, v of msgs

  validate: ->

  i18n: ->

handler = new Handler
handler.Handler = Handler
module.exports = handler
