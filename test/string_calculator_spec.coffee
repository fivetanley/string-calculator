expect = require( 'chai' ).expect

StringCalculator =
  add: (numbers)->
    if !numbers or numbers.length == 1 then return Number numbers
    negativeMatcher = /-(\d)/g
    if (negativeNumbers = numbers.match( negativeMatcher ))?
      throw new Error 'negatives not allowed. negatives: ' + negativeNumbers
    result = 0
    delimiters = [ new RegExp('\n', 'g') ]
    delimiterMatcher = /\\(.)/
    if (customDelimiter = numbers.match delimiterMatcher)?
      numbers = numbers.replace delimiterMatcher, ''
      customDelimiter = new RegExp customDelimiter[1], 'g'
      delimiters.push customDelimiter
    for delimiter in delimiters
      numbers = numbers.replace delimiter, ','
    for number in numbers.split ','
      result += Number number unless Number( number ) > 1000
    result

describe 'StringCalculator', ->

  it 'exists', ->
    expect( StringCalculator ).to.exist

  describe '#add', ->

    it 'has a method call add', ->
      expect( StringCalculator.add ).to.be.a 'function'

    describe 'when sent no arguments', ->

      result = StringCalculator.add ''
      
      it 'returns 0', ->
        expect( result ).to.equal 0

    describe 'when sent an empty string', ->

      result = StringCalculator.add ''
      
      it 'returns 0', ->
        expect( result ).to.equal 0

    describe 'when sent 1 number', ->

      result = StringCalculator.add '1'

      it 'returns that number', ->
        expect( result ).to.equal 1

    describe 'when sent 2 numbers', ->
      
      result = StringCalculator.add '1,2'

      it 'returns the sum of all numbers', ->
        expect( result ).to.equal 3

    describe 'when sent an unknown amount of numbers', ->

      result = StringCalculator.add '1,2,3,4,5'

      it 'returns the sum of all numbers', ->
        expect( result ).to.equal 15


    describe 'when sent multiple numbers with a newline delimiter', ->
      result = StringCalculator.add '1\n2,3,4,5'

      it 'handles the newline delimiter accordingly', ->
        expect( result ).to.equal 15

    describe 'when a custom delimiter is sent at beginning of string', ->
      result = StringCalculator.add '\\;1;2'

      it 'handles the delimiter accordingly', ->
        expect( result ).to.equal 3

    describe 'when negative numbers are sent in', ->
      addWithNegatives = -> StringCalculator.add '-1,2,3,4,-5'

      it 'throws an error', ->
        expect( addWithNegatives ).to.throw /negatives not allowed/

      it 'returns the negatives in the exception message', ->
        expect( addWithNegatives ).to.throw /negatives not allowed.*-1,-5/

    describe 'when numbers > 1000 are passed in', ->
      result = StringCalculator.add '1,1001'
      it 'ignores numbers > 1000', ->
        expect( result ).to.equal 1
