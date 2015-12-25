'use strict'

class Filter{
  constructor(){
    this.ruleCache = {};
    this.matchCache = {};
    this.specialCharacters = /[\*\?]/;
    this.regexCharacters = /[\-\[\]\/\{\}\(\)\+\.\\\^\$\|]/g;
    this.asterix = /\*/g;
    this.question = /\?/g;
  }
  
  convertExpression(expression) {
    var cache = this.ruleCache;
    var cached = cache[expression];
    if (cached) {
      return cached;
    }
    if (this.specialCharacters.test(expression)) {
      var converted = expression
        .replace(this.regexCharacters, "\\$&")
        .replace(this.asterix, '[\x20-\x7F]*')
        .replace(this.question, '[\x20-\x7F]');
      cached = cache[expression] = new RegExp(converted);
      return cached;
    } else {
      cache[expression] = expression;
      return expression;      
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
  
  match(value, expression) {
    if (expression.constructor === String) {
      return value === expression;
    } else if (expression.constructor === RegExp) {
      return expression.test(value);
    }
  }
    
  filter(messages, rules) {
    var result = {},
        messagesKeys;
    if((messagesKeys = Object.keys(messages)).length == 0){
      return result;
    }
    if (rules.length == 0) {
      for (var key of messagesKeys) {
        result[key] = [];
      }
      return result;
    }  
    for(let rule of rules){
      let parsedRule = this.parse(rule);
      for(let key in messages){
        if(!result[key]){
          result[key] = [];
        }
        let message = messages[key];
        if((!parsedRule.from || this.match(message.from, parsedRule.from)) 
          && (!parsedRule.to || this.match(message.to, parsedRule.to))){
          result[key].push(parsedRule.action);
        }
      }
    }
    return result;
  }
}

module.exports=Filter;
