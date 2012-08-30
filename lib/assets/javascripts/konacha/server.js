//= require konacha

mocha.reporter(function(runner) {
  var reporterRoot = parent.document.getElementById('mocha');
  return Mocha.reporters.HTML(runner, reporterRoot);
});
