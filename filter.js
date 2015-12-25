'use strict'

class Filter{
  constructor(){
    this.allowedCharset = '[\x20-\x7F]';
    this.ruleCache = {};
    this.matchCache = {};
  }
  
  convertExpression(expression) {
    var cached;
    if ((cached = this.ruleCache[expression]) != null) {
      return cached;
    }
    if (expression.indexOf('*') < 0 && expression.indexOf('?') < 0) {
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
  
  filter(messages, rules) {
    var result = {};
    if(Object.keys(messages).length == 0){
      return result;
    }
    if (rules.length == 0) {
      for (let key in messages) {
        result[key] = [];
      }
      return result;
    }  
    for(let id in rules){
      let parsedRule = this.parse(rules[id]);
      for(let key in messages){
        if(!result[key]){
          result[key] = [];
        }
        let message = messages[key];
        if((!parsedRule.from || this.match(message.from, parsedRule.from))&&(!parsedRule.to || this.match(message.to, parsedRule.to))){
          result[key].push(parsedRule.action);          
        }
      }
    }
    return result;
  }
}

module.exports=Filter;
