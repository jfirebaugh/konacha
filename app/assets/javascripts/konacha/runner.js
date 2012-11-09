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
      status:status,
      path:test.parent.path
    };

    if (status == "failed") {
      // Error objects don't serialize properly, so we copy attributes. Note
      // that iterating over test.err skips name and message.
      obj.error = {
        name: test.err.name,
        message: test.err.message,
        // We could copy stack, fileName, and lineNumber here, but they're not
        // available for AssertionErrors. If we had them reliably, we could
        // easily display them as well.
      };
    }

    return obj;
  };

  var createSuiteObject = function(suite) {
    // We need to propagate the path down the suite tree
    if (suite.parent)
      suite.path = suite.parent.path;

    var obj = {
      title:suite.title,
      fullTitle:suite.fullTitle(),
      path:suite.path
    };

    if (suite.parent)
      obj.parentFullTitle = suite.parent.fullTitle();

    return obj;
  };

  Mocha.reporters.Base.call(this, runner);

  runner.on('start', function() {
    Konacha.events = [
      {event:'start', testCount:runner.total, data:{}}
    ];
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
