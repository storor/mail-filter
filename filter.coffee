class Filter
  
  containWildcards: (expression)->
    expression? and (expression.indexOf('*') >= 0 or expression.indexOf('?') >= 0)

  convertWildcard: (expression)->
    converted = expression.replace '*', '.*'
    new RegExp converted
    
  parse: (rule) ->
    if (not rule.from and not rule.to) or (not (fromContainsWildcards = @containWildcards rule.from ) and not (toContainsWildcards = @containWildcards rule.to ))
      rule
    else
      parsed = action: rule.action
      if fromContainsWildcards
        parsed.from = @convertWildcard rule.from
      else
        parsed.from = rule.from
      if toContainsWildcards
        parsed.to = @convertWildcard rule.to
      else
        parsed.to = rule.to
      parsed
  
  match: (value, expression) ->
    if typeof expression is 'string'
      value is expression
    else if expression instanceof RegExp
      value.match expression
  
  push: (expected, applied) ->
    expected[applied.message] ?= []
    if applied.action?
      expected[applied.message].push(applied.action)
    
  apply: (key, message, rule) ->
    expected = 0
    actual = 0
    result = message: key
    if rule.from
      expected++
      actual++ if @match message.from, rule.from 
    if rule.to  
      expected++
      actual++ if @match message.to, rule.to
    if expected is actual
      result.action = rule.action
    result
  
  filter: (messages, rules) ->
    expected = {}
    unless not messages or (messagesKeys = Object.keys messages ).length is 0
      if not rules or rules.length is 0
        expected[message] = [] for message in messagesKeys
        expected      
      else
        for rule in (@parse rule for rule in rules)
          @push expected, applied for applied in (@apply key, message, rule for key, message of messages)
    expected

module.exports=Filter
