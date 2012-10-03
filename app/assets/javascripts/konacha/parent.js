window.onload = function () {
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
