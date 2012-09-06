Konacha = {
  dots: "",
  getResults: function() {
    return JSON.stringify(Konacha.results);
  }
};

mocha.reporter(function(runner) {
  Mocha.reporters.Base.call(this, runner);

  runner.on('start', function() {
    Konacha.results = [];
  });

  runner.on('pass', function(test) {
    Konacha.dots += ".";
    Konacha.results.push({
      name:test.title,
      passed:true
    });
  });

  runner.on('fail', function(test) {
    Konacha.dots += "F";
    Konacha.results.push({
      name:test.title,
      passed:false,
      message:test.err.message,
      trace:test.err.stack
    });
  });

  runner.on('pending', function(test) {
    Konacha.dots += "P";
    Konacha.results.push({
      name:test.title,
      passed:false,
      pending:true
    });
  });

  runner.on('end', function() {
    Konacha.done = true;
  });
});
