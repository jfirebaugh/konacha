//= require spec_helper
//= require jquery

describe("templating", function() {
  it("is built in to Sprockets", function() {
    $('body').html(JST['templates/hello']());
    $('body h1').text().should.equal('Hello Konacha!');
  });
});
