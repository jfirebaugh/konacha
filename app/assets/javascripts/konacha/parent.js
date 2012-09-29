window.onload = function () {
  var iframes = document.getElementsByTagName('iframe');
  for (var i = 0; i < iframes.length; ++i) {
    if (!iframes[i].contentWindow.mocha) {
      (function (path) {
        mocha.suite.addTest(new Mocha.Test(path, function () {
          throw new Error("Failed to load " + path + ". Perhaps it failed to compile?");
        }));
      })(iframes[i].getAttribute("data-path"));
    }
  }

  mocha.run();
};
