#= require array_sum

describe "Array#sum (cs)", ->
  it "returns 0 when the Array is empty", ->
    [].sum().should.equal(0);

  it "returns the sum of numeric elements", ->
    [1,2,3].sum().should.equal(6);
