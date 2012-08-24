#= require jquery

describe "the body#konacha element", ->
  it "is empty", ->
    $('#konacha').html().should.equal ''

  it "can have content added in one test...", ->
    $('#konacha').append('<h1 id="added">New Stuff</h1>')
    $('#konacha h1#added').length.should.equal(1)

  it "... that is removed before the next one starts", ->
    $('#konacha h1#added').length.should.equal(0)

  it "can have an attribute added in one test...", ->
    $('#konacha').addClass('test')

  it "... that is removed before the next one starts", ->
    $('#konacha').hasClass('test').should.be.false

  it "can be removed in one test...", ->
    $('#konacha').remove()

  it "... and is re-added before the next one starts", ->
    $('#konacha').length.should.equal(1)

  it "is visible", ->
    $('#konacha').is(':visible').should.be.true
