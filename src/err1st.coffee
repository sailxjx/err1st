class Err1st extends Error

  constructor: (@message) ->
    Error.captureStackTrace(this, arguments.callee)
    @name = 'Err1st'

  toJSON: ->
    code: @toCode()

  toCode: ->

  toStatus: ->

  toMsg: -> @message

  toData: -> @data

  stringify: -> JSON.stringify(@toJSON())

module.exports = Err1st
