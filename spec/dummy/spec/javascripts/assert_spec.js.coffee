describe "assert styles", ->
  it "supports expect style", ->
    expect(2 + 2).to.equal(4)

  it "supports should style", ->
    (2 + 2).should.equal(4)

  it "supports assert style", ->
    assert.equal(2 + 2, 4)
