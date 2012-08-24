mocha.setup(Konacha.mochaOptions);

mocha.suite.beforeEach(function () {
  Konacha.reset();
});

var expect = chai.expect,
    should = chai.should(),
    assert = chai.assert;

window.onload = function () {
  mocha.run();
};
