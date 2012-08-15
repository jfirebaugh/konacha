//= require spec_helper

describe('ruby fixtures', function() {
  it('loads ruby_fixtures.rb', function() {
    Konacha.getFixtures().foo.bar.should.equal(42);
  });
});
