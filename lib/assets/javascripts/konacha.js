mocha.setup(Konacha.mochaOptions);

beforeEach(function () {
  var e = document.getElementById('konacha'),
  p = e.parentNode;

  p.removeChild(e);

  e = document.createElement("div");
  e.id = "konacha";

  p.appendChild(e);
});

var expect = chai.expect,
    should = chai.should(),
    assert = chai.assert;

window.onload = function () {
  mocha.run();
};
