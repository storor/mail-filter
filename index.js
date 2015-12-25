var filter = require('./filter');

global.filter = module.exports = (messages, rules)=>
  filter.filter(messages, rules);
