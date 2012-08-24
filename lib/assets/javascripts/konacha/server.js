//= require konacha/common

Konacha.mochaOptions = {
  ui: 'bdd',

  reporter: function(runner) {
    var reporterRoot = parent.document.getElementById('mocha');

    return mocha.reporters.HTML(runner, reporterRoot);
  }
};
