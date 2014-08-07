class Err1st extends Error

  constructor: (phrase, @msgData...) ->
    Error.captureStackTrace(this, arguments.callee)
    if phrase instanceof Error
      @message = phrase.message
      @phrase = phrase.message
    else
      @message = phrase
      @phrase = phrase
    @name = 'Err1st'

    Object.defineProperties this,
      longcode:
        get: -> @_longcode
        set: (longcode) ->
          @_longcode = Number(longcode)
          @code = Number(String(longcode)[3..])
          @status = Number(String(longcode)[0..2])

  toJSON: ->
    code: @code
    message:  @message

  toCode: -> @code

  toStatus: -> @status

  toPhrase: -> @phrase

  toMsg: -> @message

  stringify: -> JSON.stringify(@toJSON())

  DNA: 'err1st'

module.exports = Err1st
