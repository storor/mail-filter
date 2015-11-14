class Filter
  
  containWildcards: (expression)->
    expression? and (expression.indexOf('*') >= 0 or expression.indexOf('?') >= 0)

  parse: (rule) ->
    rule if (not rule.from and not rule.to) or (not @containWildcards(rule.from) and not @containWildcards(rule.to))
  
  match: (value, expression) ->
    if typeof expression is 'string'
      value is expression
  
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
