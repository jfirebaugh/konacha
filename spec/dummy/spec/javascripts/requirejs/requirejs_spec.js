require(["requirejs/module"], function(module) {
  describe("module loading with require outside 'describe'", function(){
    it("works with done", function(done){
      module.name.should.equal("module");
      module.subModule.name.should.equal("sub_module");
      done();
    });

    it("works without done", function(){
      module.name.should.equal("module");
      module.subModule.name.should.equal("sub_module");
    });

    it("fails when using done, but it isn't called", function(done){
      module.name.should.equal("module");
      module.subModule.name.should.equal("sub_module");
    });
  });
});

describe("with require inside 'it'", function(){
  it("incorrect module names fail with done", function(done){
    require(["requirejs/notamodule"], function(module) {
      module.name.should.equal("module");
      module.subModule.name.should.equal("sub_module");
      done();
    });
  });

  // TODO(billmag) Incorrect module names succeed without done, which is shitty because
  // as seen above, tests will otherwise work. (i.e. this passes, but it shouldn't)
  it("incorrect module names fail with done", function(){
    require(["requirejs/notamodule"], function(module) {
      module.name.should.equal("module");
      module.subModule.name.should.equal("sub_module");
    });
  });
});

// TODO(billmag) Incorrect module names cause tests to get skipped if require is on the outside
// because the describe/it code never gets executed. Thus, I'd expect some kind of failure here,
// but instead nothing executes.
require(["requirejs/notamodule"], function(module) {
  describe("a failed module load", function(){
    it("should cause a failure", function(done){
      module.name.should.equal("module");
      module.subModule.name.should.equal("sub_module");
    });
  });
});