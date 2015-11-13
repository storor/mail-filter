filter = (messeges, filters) ->
  expected = 
    msg1: ['folder jack', 'forward to jill@elsewhere.com']
    msg2: ['tag spam', 'forward to jill@elsewhere.com']
    msg3: ['tag work']

module.exports = filter
