Konacha = {
  getEvents: function() {
    return JSON.stringify(Konacha.events);
  }
};

mocha.reporter(function(runner) {
  var createTestObject = function(test, status) {
    var obj = {
      title:test.title,
      fullTitle:test.fullTitle(),
      duration:test.duration,
      parentFullTitle:test.parent.fullTitle(),
      status:status
    };

    if (status == "failed")
      obj.error = test.err; // Contains message, expected, actual, operator, stack

    return obj;
  };

  var createSuiteObject = function(suite) {
    var obj = {
      title:suite.title,
      fullTitle:suite.fullTitle()
    };

    if (suite.parent)
      obj.parentFullTitle = suite.parent.fullTitle();

    return obj;
  };

  Mocha.reporters.Base.call(this, runner);

  runner.on('start', function() {
    Konacha.events = [];
  });

  runner.on('suite', function(suite) {
    if (suite.fullTitle() && suite.fullTitle().length > 0)
      Konacha.events.push({event:'suite', data:createSuiteObject(suite), type:'suite'});
  });

  runner.on('test', function(test) {
    Konacha.events.push({event:'test', data:createTestObject(test), type:'test'});
  });

  runner.on('pass', function(test) {
    Konacha.events.push({event:'pass', data:createTestObject(test, "passed"), type:'test'});
  });

  runner.on('fail', function(test) {
    Konacha.events.push({event:'fail', data:createTestObject(test, "failed"), type:'test'});
  });

  runner.on('pending', function(test) {
    Konacha.events.push({event:'pending', data:createTestObject(test, "pending"), type:'test'});
  });

  runner.on('suite end', function(suite) {
    if (suite.fullTitle() && suite.fullTitle().length > 0)
      Konacha.events.push({event:'suite end', data:createSuiteObject(suite), type:'suite'});
  });

  runner.on('end', function() {
    Konacha.events.push({event:'end', data:{}});
  });
});
