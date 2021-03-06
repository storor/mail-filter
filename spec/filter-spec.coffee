filter = require '../filter'

describe "Filter Object", ->
  
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
        
    describe "apply", ->
      it "should compare with string value of rule if it has no wildcards", ->
        msg = from: 'a', to: 'b'
        rule = from: 'a', action: 'c'
        actual = filter.apply msg, rule
        expect(actual).toEqual 'c'
      
      describe "match", ->
        it "should return yes if strings are equal", ->
          expect(filter.match 'a', 'a').toBeTruthy()

        it "should return no if strings are not equal", ->
          expect(filter.match 'a', 'b').not.toBeTruthy()
