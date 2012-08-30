mocha.ui('bdd');

window.Konacha = {
  reset: function() {
    document.body = document.createElement('body');
    document.body.id = 'konacha';
  }
};

mocha.suite.beforeEach(function () {
  Konacha.reset();
});

var expect = chai.expect,
    should = chai.should(),
    assert = chai.assert;

window.onload = function () {
  mocha.run();
};
