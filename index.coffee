Filter = require './filter'

filter = new Filter()

module.exports = (messages, rules)->
  filter.filter messages, rules
