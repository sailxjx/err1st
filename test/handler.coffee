should = require('should')
Err = require('../lib')
{handler} = require('../lib')

describe 'handler', ->

  handler.validate ->
    @localeDir = "#{__dirname}/locales"
    @locales = ['en', 'zh']
    @map =
      DB_ERROR: [500101, '数据库错误']
      NO_OBJECT: 674621
      UPDATE_ERROR: [
        500102,
        (field) ->
          "#{field} 更新错误"
      ]
      LANG_ERROR: [500201]
      STRING_ERROR: [123455, 'something wrong']

  describe 'handler#validate', ->

    it 'should format map in the correct data structure', ->
      handler.map.DB_ERROR.code.should.be.eql(500101)

    it 'should accept non-object map', ->
      handler.map.NO_OBJECT.code.should.be.eql(674621)

    it 'should init i18n dictionary on validate', ->
      _handler = new handler.Handler
      _handler.validate ->
        @localeDir = "#{__dirname}/locales"
        @locales = ['en', 'zh']
      _handler._i18n['en'].should.have.properties('LANG_ERROR', 'NONE_CODE_ERROR')
      _handler.validate ->
        @localeDir = "#{__dirname}/localesmerge"
        @locales = ['en', 'zh']
      _handler._i18n['en'].should.have.properties('LANG_ERROR', 'NONE_CODE_ERROR', 'MERGE_ERROR')
      _handler._i18n['zh'].NONE_CODE_ERROR.should.be.eql('覆盖错误码')

  describe 'handler#parse', ->

    it 'should parse the correct message', ->
      err = new Err('UPDATE_ERROR', 'name')
      err = handler.parse(err)
      err.toMsg().should.be.eql('name 更新错误')

    it 'should parse the correct message in English', ->
      err = new Err('LANG_ERROR', 'Jerry')

      err = handler.parse(err)
      err.toMsg().should.be.eql("Hello Jerry, You've got an error")

      errZh = handler.parse(err, {lang: 'zh'})
      errZh.toMsg().should.be.eql('你好 Jerry, 你得到了一个错误')

    it 'should parse the string typed error', ->
      handler.parse('STRING_ERROR').toMsg().should.be.eql("something wrong")

    it 'should use default err when not defined', ->
      handler.parse('undefined').toMsg().should.be.eql('Unknown Error')

    it 'should return the default error with specific message', ->
      err = new Err('NONE_CODE_ERROR')
      errEn = handler.parse(err)
      errEn.toMsg().should.be.eql('none code error')
      errEn.toCode().should.be.eql(100)

      errZh = handler.parse(err, {lang: 'zh'})
      errZh.toMsg().should.be.eql('无错误码')
      errZh.toCode().should.be.eql(100)

  describe 'handler#customErrorName', ->

    it 'should have custom error name', ->

      _handler = new handler.Handler
      _handler.validate ->
        @name = 'CustomError'
        @map =
          UPDATE_ERROR: [500102, "更新错误"]

        err = new Err("UPDATE_ERROR")
        _handler.parse(err).toString().should.be.eql('CustomError: 更新错误')

  describe 'handler#restore', ->

    it 'should get correct Err object from code', ->
      err = new Err('DB_ERROR')
      console.log err.toString()
      handler.restore(101).toString().should.be.eql(err.toString())
