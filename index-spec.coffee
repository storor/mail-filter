filter = require './index'
describe "Filter function", ->
  
  it "should be a function", ->
    expect(typeof filter).toEqual('function')
  
  input = null
  rules = null
  expected = null
  
  beforeEach ->
    input = 
      msg1: 
        from: 'jack@example.com', to: 'jill@example.org'
      msg2: 
        from: 'noreply@spam.com', to: 'jill@example.org'
      msg3: 
        from: 'boss@work.com', to: 'jack@example.com'
    rules = [
      {from: '*@work.com', action: 'tag work'},
      {from: '*@spam.com', action: 'tag spam'},
      {from: 'jack@example.com', to: 'jill@example.org', action: 'folder jack'},
      {to: 'jill@example.org', action: 'forward to jill@elsewhere.com'}
    ]
    expected = 
      msg1: ['folder jack', 'forward to jill@elsewhere.com']
      msg2: ['tag spam', 'forward to jill@elsewhere.com']
      msg3: ['tag work']
  
  it "should filter and match rules", ->
    actual = filter input, rules
    expect(actual).toEqual(expected)
  
  xit "has to apply rule with no 'from' and 'to' to all messages", ->
    action = 'universal rule'
    actual = filter input, [{action: action}]
    expect(actual).toEqual
      msg1: [action]
      msg2: [action]
      msg3: [action]
  
  it "should return empty object if empty params are passed", ->
    actual = filter {}, []
    expect(actual).toEqual {}
  
  it "should return empty object if no messages are passed", ->
    actual = filter {}, rules
    expect(actual).toEqual {}
    
  it "should return object with empty rule array if no rules are passed", ->
    actual = filter input, []
    expect(actual).toEqual
      msg1: []
      msg2: []
      msg3: []
