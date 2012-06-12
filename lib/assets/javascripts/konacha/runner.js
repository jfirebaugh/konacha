window.Konacha = {
  dots:"",

  mochaOptions: {
    ui: 'bdd',

    reporter: function (runner) {
      window.mocha.reporters.Base.call(this, runner);

      runner.on('start', function () {
        Konacha.results = [];
      });

      runner.on('pass', function (test) {
        Konacha.dots += ".";
        Konacha.results.push({
          name:test.fullTitle(),
          passed:true
        });
      });

      runner.on('fail', function (test) {
        Konacha.dots += "F";
        Konacha.results.push({
          name:test.fullTitle(),
          passed:false,
          message:test.err.message,
          trace:test.err.stack
        });
      });

      runner.on('end', function () {
        Konacha.done = true;
      });
    }
  },

  getResults:function () {
    return JSON.stringify(Konacha.results);
  }
};
