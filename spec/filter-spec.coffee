Filter = require '../filter'

describe "Filter Object", ->
  filter = null
  beforeEach ->
    filter = new Filter()
  
  it "should be defined", ->
    expect(filter).toBeDefined()
    
  describe "parse rule", ->
    
    describe "parse", ->
      it "should return rule in its original state if there were no wildcards", ->
        rule = action: 'an action'
        expect(filter.parse rule).toEqual(rule)
        rule = action: 'an action', to: 'abc'
        expect(filter.parse rule).toEqual(rule)
        rule = action: 'an action', to: 'abc', from: 'cde'
        expect(filter.parse rule).toEqual(rule)
        rule = action: 'an action', from: 'cde'
        expect(filter.parse rule).toEqual(rule)
        
      it "should escape special RegExp characters in a string", ->
        actual = filter.convertExpression '*abc.'
        expect(actual).toEqual(new RegExp("[\x20-\x7F]*abc\\."))
        
      describe "convertExpression", ->
        it "should return regexp instead of string with wildcards ", ->
          actual = filter.convertExpression '*abc'
          expect(actual).toEqual(new RegExp("[\x20-\x7F]*abc"))
          actual = filter.convertExpression '?abc'
          expect(actual).toEqual(new RegExp("[\x20-\x7F]abc"))
          actual = filter.convertExpression '?abc?'
          expect(actual).toEqual(new RegExp("[\x20-\x7F]abc[\x20-\x7F]"))
