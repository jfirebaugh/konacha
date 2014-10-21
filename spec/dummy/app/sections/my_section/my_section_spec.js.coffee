#= require ./my_section

describe "MySection", ->
  describe '#number_one', ->
    it "returns 1", ->
      MySection.number_one().should.equal 1
