//= require spec_helper

describe("templating", function(){
  it("is built in to Sprockets", function(){
    $('#test').html(JST['templates/hello']());
    $('#test h1').text().should.equal('Hello Matcha!');
  });
});
