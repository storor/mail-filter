class Filter
  
  allowedCharset: '[\x20-\x7F]'
  ruleCache: {}
  matchCache: {}
  cacheHit: 0
  cachePut: 0
  
  containWildcards: (expression)->
    expression? and (expression.indexOf('*') >= 0 or expression.indexOf('?') >= 0)

  convertExpression: (expression)->
    return cached if (cached = @ruleCache[expression])?
    if not @containWildcards expression
      @ruleCache[expression] = expression
      return expression
    else
      converted = expression
        .replace /\*/g, "#{@allowedCharset}*"
        .replace /\?/g, @allowedCharset
      cached = @ruleCache[expression] = new RegExp converted
      return cached
    
  parse: (rule) ->
    if (not rule.from and not rule.to)
      return rule
    parsed = action: rule.action
    parsed.from = @convertExpression rule.from if rule.from
    parsed.to = @convertExpression rule.to if rule.to
    return parsed
  
  cacheMatch: (value, expression) ->
    exp = @matchCache[expression]
    if exp and typeof (res = exp[value]) is 'boolean'
      # console.log 'cacheHit'
      return res
    matches = @match value, expression
    exp = (@matchCache[expression] = {}) if not exp
    # console.log 'cachePut'
    exp[value] = matches
    return matches
  
  match: (value, expression) ->
    if typeof expression is 'string'
      matches = value is expression
    else if expression instanceof RegExp
      matches = expression.test value
    return matches
  
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
    result = {}
    unless not messages or (messagesKeys = Object.keys messages ).length is 0
      if not rules or rules.length is 0
        result[message] = [] for message in messagesKeys
        result
      else
        for rule in (@parse rule for rule in rules)
          @push result, applied for applied in (@apply key, message, rule for key, message of messages)
    result

module.exports=Filter
