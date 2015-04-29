Err = require '../lib/err1st.js'
en = require './en'
zh = require './zh'

Err.meta SOMETHING_WRONG: 500100
Err.localeMeta 'zh', zh
Err.localeMeta 'en', en

err = new Err('SOMETHING_WRONG', 'Alice')

console.log err.message
console.log err.stack
console.log err.locale('en').message
console.log err.locale('en').stack
