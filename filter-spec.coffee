Filter = require './filter'

describe "Filter Object", ->
  filter = null
  beforeEach ->
    filter = new Filter()
  
  it "should be defined", ->
    expect(filter).toBeDefined()
    
  describe "parse rule", ->
    describe "containWildcards", ->
      it "should return true if there is a wildcard", ->
        expect(filter.containWildcards '*smth' ).toBeTruthy()  
        expect(filter.containWildcards '?smth' ).toBeTruthy()  
        expect(filter.containWildcards 'smth' ).not.toBeTruthy()
    describe "parse", ->
      it "should return rule in its original state if there were no wildcards", ->
        rule = action: 'an action'
        expect(filter.parse rule).toBe(rule)
        rule = action: 'an action', to: 'abc'
        expect(filter.parse rule).toBe(rule)
        rule = action: 'an action', to: 'abc', from: 'cde'
        expect(filter.parse rule).toBe(rule)
        rule = action: 'an action', from: 'cde'
        expect(filter.parse rule).toBe(rule)
      
    describe "apply", ->
      it "should compare with string value of rule if it has no wildcards", ->
        msg = from: 'a', to: 'b'
        rule = from: 'a', action: 'c'
        actual = filter.apply 'msg', msg, rule 
        expect(actual).toEqual  
          message: 'msg'
          action: rule.action
      
      describe "match", ->
        it "should return yes if strings are equal", ->
          expect(filter.match 'a', 'a').toBeTruthy()

        it "should return no if strings are not equal", ->
          expect(filter.match 'a', 'b').not.toBeTruthy()
