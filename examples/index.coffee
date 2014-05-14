Err = require '../lib/index.js'
{handler} = Err
err = new Err('SOMETHING_WRONG', 'Alice')

handler.validate ->
  @localeDir = __dirname
  @locales = ['en', 'zh']
  @map =
    SOMETHING_WRONG: 500100

# throw handler.parse err
throw handler.parse err, lang: 'zh'
