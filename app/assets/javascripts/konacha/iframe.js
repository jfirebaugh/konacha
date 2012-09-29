window.mocha = parent.mocha;
window.Mocha = parent.Mocha;

window.Konacha = {
  reset: function() {
    document.body = document.createElement('body');
    document.body.id = 'konacha';
  }
};

var suite = Mocha.Suite.create(mocha.suite);

mocha.ui = function (name) {
  this._ui = Mocha.interfaces[name];
  if (!this._ui) throw new Error('invalid interface "' + name + '"');
  this._ui = this._ui(suite);
  suite.emit('pre-require', window, null, this);
  return this;
};

mocha.ui('bdd');

suite.beforeAll(function () {
  var contexts = parent.document.getElementsByClassName("test-context");
  for (var i = 0; i < contexts.length; ++i) {
    if (contexts[i].contentWindow == window) {
      contexts[i].style.display = "block";
    } else {
      contexts[i].style.display = null;
    }
  }
});

suite.beforeEach(function () {
  Konacha.reset();
});

var expect = chai.expect,
    should = chai.should(),
    assert = chai.assert;
