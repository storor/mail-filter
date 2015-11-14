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
