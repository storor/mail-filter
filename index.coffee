Filter = require './filter'

filter = new Filter()

global.filter = module.exports = (messages, rules)->
  filter.filter messages, rules
