mocha.ui('tdd');

suite('UI', function () {
  test('supports alternate mocha UIs', function () {
    (2 + 2).should.equal(4);
  });
});
