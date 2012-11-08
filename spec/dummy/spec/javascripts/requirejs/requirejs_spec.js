describe("with require inside 'it'", function(){
  it("incorrect module names fail with done", function(done){
    require(["requirejs/notamodule"], function() {
      done();
      // Both mocha's done and requirejs's errback function take in an error, so in this case a module load failure
      // should immediately fail the build.
    }, done);
  });

  it("correct module names work with done.", function(done){
    require(["requirejs/module"], function(module) {
      module.name.should.equal("module");
      module.subModule.name.should.equal("sub_module");
      done();
    });
  });
});

describe("with a valid require in 'before'", function () {
  var module;
  before(function(done) {
    require(["requirejs/module"], function (loadedModule) {
      module = loadedModule;
      done();
    }, done);
  });
  describe("these should work", function(){
    it("sync test", function(){
      module.name.should.equal("module");
      module.subModule.name.should.equal("sub_module");
    });

    it("async test", function(done){
      module.name.should.equal("module");
      module.subModule.name.should.equal("sub_module");
      done();
    });
  });
});

// TODO(billmag) - Due to an issue with Konacha's handling of failures in before() calls, this is
// listed last. See: https://github.com/visionmedia/mocha/issues/581
describe("with an invalid require in 'before' there should be failure", function () {
  var module;
  before(function(done) {
    require(["requirejs/notamodule"], function (loadedModule) {
      module = loadedModule;
      done();
    }, done);
  });
  describe("these won't execute", function(){
      it("sync test", function(){
      });

      it("async test", function(done){
        done();
      });
  });
});