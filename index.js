var Filter = require('./filter');

var filter = new Filter();

global.filter = module.exports = (messages, rules)=>
  filter.filter(messages, rules);
