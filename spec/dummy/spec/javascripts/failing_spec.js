describe("failure", function(){
  it("fails", function(){
    (2 + 2).should.equal(5);
  });

  it("errors", function() {
    // Mocha catches and re-throws string exceptions, so we only need to test
    // throwing real Error objects.
    throw new Error("this one errors out");
  });

  it("errors asynchronously", function(done) {
    setTimeout(function() {
      (2 + 2).should.equal(5);
    }, 0);
    setTimeout(function() {
      done();
    }, 10);
  });
});
