'use strict'

var allowedCharset = '[\x20-\x7F]';
var ruleCache = {};
var matchCache = {};
  
function convertExpression(expression){
  var cached;
  if ((cached = ruleCache[expression])) {
    return cached;
  }
  if (!(expression && (expression.indexOf('*') >= 0 || expression.indexOf('?') >= 0))) {
    ruleCache[expression] = expression;
    return expression;
  } else {
    var converted = expression
      .replace(/[\-\[\]\/\{\}\(\)\+\.\\\^\$\|]/g, "\\$&")
      .replace(/\*/g, allowedCharset + "*")
      .replace(/\?/g, allowedCharset);
    cached = ruleCache[expression] = new RegExp(converted);
    return cached;
  }
}
  
function parse(rule){
  if (!rule.from && !rule.to) {
    return rule;
  }
  var parsed = {
    action: rule.action
  };
  if (rule.from) {
    parsed.from = convertExpression(rule.from);
  }
  if (rule.to) {
    parsed.to = convertExpression(rule.to);
  }
  return parsed;
}
  
  /*Is proven to be useless and harmful*/
function cacheMatch(value, expression){
  let cached = matchCache[expression];
  let matches;    
  if(cached && typeof (matches = cached[value]) == 'boolean'){
    return matches;
  }
  matches = match(value, expression);
  if(!cached){
    cached = matchCache[expression] = {};
  }
  cached[value] = matches;
  return matches;
}
  
function match(value, expression){
  if (typeof expression == 'string') {
    return value === expression;
  } else if (expression instanceof RegExp) {
    return expression.test(value);
  }
}
  
function apply(message, rule){
  let actual = 0
  let expected = 0;
  if (rule.from) {
    expected++;
    if (match(message.from, rule.from)) {
      actual++;
    }
  }
  if (rule.to) {
    expected++;
    if (match(message.to, rule.to)) {
      actual++;
    }
  }
  if (expected == actual) {
    return rule.action;
  }
}
  
function filter(messages, rules){
  var result = {},
      messagesKeys;
  if(!messages || (messagesKeys = Object.keys(messages)).length == 0){
    return result;
  }
  if (!rules || rules.length == 0) {
    for (var key of messagesKeys) {
      result[key] = [];
    }
    return result;
  }  
  for(let rule of rules){
    let parsedRule = parse(rule);
    for(let key in messages){
      let applied = apply(messages[key], parsedRule);
      if(!result[key]){
        result[key] = [];
      }
      if(applied){
        result[key].push(applied);
      }
    }
  }
  return result;
}

module.exports = {
  filter: filter,
  convertExpression: convertExpression,
  parse: parse,
  apply: apply,
  match: match,
  allowedCharset: allowedCharset
}
