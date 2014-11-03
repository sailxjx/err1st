class Err1st extends Error

  constructor: (phrase, @msgData...) ->
    Error.captureStackTrace(this, arguments.callee)
    if phrase instanceof Error
      @message = phrase.message
      @phrase = phrase.message
      @code = phrase.code
      @status = phrase.status
    else
      @message = phrase
      @phrase = phrase
    @name = 'Err1st'

    Object.defineProperties this,
      longcode:
        get: -> @_longcode
        set: (longcode) ->
          @_longcode = Number(longcode)
          @code or= Number(String(longcode)[3..])
          @status or= Number(String(longcode)[0..2])

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
