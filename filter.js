'use strict'

class Filter{
  constructor(){
    this.allowedCharset = '[\x20-\x7F]';
    this.ruleCache = {};
    this.matchCache = {};
    this.cacheHit = 0;
    this.cachePut = 0;    
  }
  
  containWildcards(expression){
    return expression && (expression.indexOf('*') >= 0 || expression.indexOf('?') >= 0);    
  }
  
  convertExpression(expression) {
    var cached;
    if ((cached = this.ruleCache[expression]) != null) {
      return cached;
    }
    if (!this.containWildcards(expression)) {
      this.ruleCache[expression] = expression;
      return expression;
    } else {
      var converted = expression
        .replace(/[\-\[\]\/\{\}\(\)\+\.\\\^\$\|]/g, "\\$&")
        .replace(/\*/g, this.allowedCharset + "*")
        .replace(/\?/g, this.allowedCharset);
      cached = this.ruleCache[expression] = new RegExp(converted);
      return cached;
    }
  }
  
  parse(rule) {
    var parsed;
    if (!rule.from && !rule.to) {
      return rule;
    }
    parsed = {
      action: rule.action
    };
    if (rule.from) {
      parsed.from = this.convertExpression(rule.from);
    }
    if (rule.to) {
      parsed.to = this.convertExpression(rule.to);
    }
    return parsed;
  }
  
  /*Is proven to be useless and harmful*/
  cacheMatch(value, expression) {
    let cached = this.matchCache[expression];
    let matches;    
    if(cached && typeof (matches = cached[value]) == 'boolean'){
      return matches;
    }
    matches = this.match(value, expression);
    if(!cached){
      cached = this.matchCache[expression] = {};
    }
    cached[value] = matches;
    return matches;
  }
  
  match(value, expression) {
    if (typeof expression == 'string') {
      return value === expression;
    } else if (expression instanceof RegExp) {
      return expression.test(value);
    }
  }
  
  apply(message, rule) {
    let actual = 0
    let expected = 0;
    if (rule.from) {
      expected++;
      if (this.match(message.from, rule.from)) {
        actual++;
      }
    }
    if (rule.to) {
      expected++;
      if (this.match(message.to, rule.to)) {
        actual++;
      }
    }
    if (expected == actual) {
      return rule.action;
    }
  }
  
  filter(messages, rules) {
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
      let parsedRule = this.parse(rule);
      for(let key in messages){
        let applied = this.apply(messages[key], parsedRule);
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
}

module.exports=Filter;
