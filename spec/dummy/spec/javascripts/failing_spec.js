describe("failure", function(){
  it("fails", function(){
    (2 + 2).should.equal(5);
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
