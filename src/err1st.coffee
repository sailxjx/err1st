class Err1st extends Error

  constructor: (phrase, @msgData...) ->
    Error.captureStackTrace(this, arguments.callee)
    @name = 'Err1st'
    @message = phrase
    @phrase = phrase

  toJSON: ->
    code: @toCode()
    message:  @toMsg()

  toCode: -> Number(String(@code)[3..]) if @code?

  toStatus: -> Number(String(@code)[0..2]) if @code?

  toPhrase: -> @phrase

  toMsg: -> @message

  stringify: -> JSON.stringify(@toJSON())

module.exports = Err1st
