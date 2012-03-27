//= require spec_helper
//= require jquery

describe("templating", function(){
  it("is built in to Sprockets", function(){
    $('#konacha').html(JST['templates/hello']());
    $('#konacha h1').text().should.equal('Hello Konacha!');
  });
});
