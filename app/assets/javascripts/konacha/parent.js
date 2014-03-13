window.onload = function () {
  // The iframe order is undefined, so we make it predictable.
  mocha.suite.suites.sort(function (a, b) {
    return a.path.localeCompare(b.path);
  });

  var originalTestUrl = Mocha.reporters.HTML.prototype.testURL;

  Mocha.reporters.HTML.prototype.suiteURL = function(suite) {
    var specFilePath,
        grepString = originalTestUrl(suite),
        currentSuite = suite;

    while (!(specFilePath = currentSuite.path)) {
      currentSuite = currentSuite.parent
    }

    specFilePath = /([^\.]*)/.exec(specFilePath)[1];
    return location.protocol+'//'+location.host+'/'+specFilePath+grepString;
  };

  Mocha.reporters.HTML.prototype.testURL = Mocha.reporters.HTML.prototype.suiteURL;

  // Check that all iframes loaded successfully.
  var iframes = document.getElementsByTagName('iframe');
  for (var i = 0; i < iframes.length; ++i) {
    if (!iframes[i].contentWindow.mocha) {
      (function (path) {
        mocha.suite.addTest(new Mocha.Test(path, function () {
          throw new Error("Failed to load " + path + ".\n" +
                          "Perhaps it failed to compile? Check the rake output for errors.");
        }));
      })(iframes[i].getAttribute("data-path"));
    }
  }

  mocha.run();
};
