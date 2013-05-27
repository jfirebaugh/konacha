window.onload = function () {
  // The iframe order is undefined, so we make it predictable.
  mocha.suite.suites.sort(function (a, b) {
    return a.path.localeCompare(b.path);
  });

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

  var runner = mocha.run();

  // update global error handlers on each frame to match the parent
  var updateFrameErrorHandlers = function() {
    for (var i = 0; i < iframes.length; ++i) {
      iframes[i].contentWindow.onerror = window.onerror;
    }
  };

  // now that the runner has started, we can install Mocha's global error
  // handler on each frame.
  var _mochaGlobalError = window.onerror;
  window.onerror = function() {
    _mochaGlobalError.apply(this, arguments);
    // return false so Poltergeist doesn't try to capture the error directly
    return false;
  };
  updateFrameErrorHandlers();

  // clean up error handlers when tests are done
  runner.on("end", function() {
    updateFrameErrorHandlers();
  });
};
