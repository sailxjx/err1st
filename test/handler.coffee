should = require('should')
Err = require('../lib')
{handler} = require('../lib')

describe 'handler', ->

  describe 'handler#validate', ->

    it 'should format map in the correct data structure', ->
      handler.validate ->
        @map =
          DB_ERROR: [500101, '数据库错误']
        handler.map.DB_ERROR.code.should.be.eql(500101)

  describe 'handler#parse', ->

    it 'should parse the correct message', ->

      handler.validate ->
        @map =
          UPDATE_ERROR: [
            500102,
            (field) ->
              "#{field} 更新错误"
          ]

      err = new Err('UPDATE_ERROR', 'name')
      err = handler.parse(err)
      err.toMsg().should.be.eql('name 更新错误')

    it 'should parse the correct message in English', ->

      handler.validate ->
        @localeDir = "#{__dirname}/locales"
        @locales = ['en', 'zh']
        @map =
          LANG_ERROR: [500201]

        err = new Err('LANG_ERROR', 'Jerry')
        err = handler.parse(err)
        err.toMsg().should.be.eql("Hello Jerry, You've got an error")
        errZh = handler.parse(err, {lang: 'zh'})
        errZh.toMsg().should.be.eql('你好 Jerry, 你得到了一个错误')
