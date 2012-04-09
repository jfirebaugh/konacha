//= require spec_helper

describe("Konacha.mochaOptions", function(){
  it("overrides the default globals ignore", function(){
    var options = Konacha.mochaOptions;
    options.globals.should.not.be.undefined;
    options.globals.should.eql(['YUI']);
  });
});
