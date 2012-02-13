describe "transactions", ->
  it "should add stuff in one test...", ->
    $('#test').append('<h1 id="added">New Stuff</h1>')
    $('#test h1#added').length.should.equal(1)

  it "... should have been removed before the next starts", ->
    $('#test h1#added').length.should.equal(0)
