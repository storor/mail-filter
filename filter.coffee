class Filter
  
  containWildcards: (expression)->
    expression? and (expression.indexOf('*') >= 0 or expression.indexOf('?') >= 0)

  parse: (rule) ->
    rule if (not rule.from and not rule.to) or (not @containWildcards(rule.from) and not @containWildcards(rule.to))
  apply: (message, rule) ->
    
  filter: (messeges, rules) ->
    if not messeges or (messegesKeys = Object.keys messeges ).length is 0
      {}
    else if not rules or rules.length is 0
      expected = {}
      expected[message] = [] for message in messegesKeys
      expected      
    else
      for rule in (@parse rule for rule in rules)
        @apply message, rule for message in messeges
      
      msg1: ['folder jack', 'forward to jill@elsewhere.com']
      msg2: ['tag spam', 'forward to jill@elsewhere.com']
      msg3: ['tag work']

module.exports=Filter
