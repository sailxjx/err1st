should = require('should')
Err = require('../lib')

describe 'err1st', ->

  name = 'Err1st'

  describe 'err1st#captureStackTrace', ->

    it 'should return the same stack string as Error', ->
      stackErrors = []
      stackErrs = []
      try
        throw new Error('error')
      catch e
        stackErrors = e.stack.split('\n')[2..]

      try
        throw new Err('error')
      catch e
        stackErrs = e.stack.split('\n')[2..]

      stackErrs.should.be.eql(stackErrors)

  describe 'err1st#name', ->

    it "should have name #{name}", ->
      err = new Err('error')
      err.toString().should.eql("#{name}: error")
