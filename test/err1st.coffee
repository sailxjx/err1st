should = require 'should'
Err = require '../src'

describe 'err1st', ->

  name = 'Err1st'

  _compareStack = (err, error) ->
    stackErrors = error.stack.split('\n')[2..]
    stackErrs = err.stack.split('\n')[2..]
    stackErrs.should.be.eql(stackErrors)

  describe 'err1st#captureStackTrace', ->

    it 'should return the same stack string as Error', ->
      try
        throw new Error('error')
      catch e
        error = e
      try
        throw new Err('error')
      catch e
        err = e
      _compareStack(err, error)

  describe 'err1st#name', ->

    it "should have name #{name}", ->
      err = new Err('error')
      err.toString().should.eql("#{name}: error")

  describe 'err1st#constructor', ->

    it 'should return the Err1st Object by original Error Object', ->
      error = new Error('Original')
      err = new Err(error)
      err.toString().should.eql("#{name}: Original")
      _compareStack(err, error)
