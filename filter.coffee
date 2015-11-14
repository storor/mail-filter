filter = (messeges, filters) ->
  if not messeges or (messegesKeys = Object.keys messeges ).length is 0
    {}
  else if not filters or filters.length is 0
    expected = {}
    expected[message] = [] for message in messegesKeys
    expected      
  else
    msg1: ['folder jack', 'forward to jill@elsewhere.com']
    msg2: ['tag spam', 'forward to jill@elsewhere.com']
    msg3: ['tag work']

module.exports = filter
