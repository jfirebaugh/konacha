(function () {
  window.Konacha = {
    dots:"",

    Reporter:function (runner) {
      window.mocha.reporters.Base.call(this, runner);

      runner.on('start', function () {
        Konacha.results = [];
      });

      runner.on('pass', function (test) {
        Konacha.dots += ".";
        Konacha.results.push({
          name: test.title,
          passed: true
        });
      });

      runner.on('fail', function (test) {
        Konacha.dots += "F";
        Konacha.results.push({
          name: test.title,
          passed: false,
          message: test.err.message,
          trace: test.err.stack
        });
      });

      runner.on('end', function () {
        Konacha.done = true;
      });
    },

    getResults:function () {
      return JSON.stringify(Konacha.results);
    }
  };

  var suite = new mocha.Suite
    , utils = mocha.utils
    , Reporter = Konacha.Reporter;

  function parse(qs) {
    return utils.reduce(qs.replace('?', '').split('&'), function(obj, pair){
        var i = pair.indexOf('=')
          , key = pair.slice(0, i)
          , val = pair.slice(++i);

        obj[key] = decodeURIComponent(val);
        return obj;
      }, {});
  }

  mocha.setup = function (ui) {
    ui = mocha.interfaces[ui];
    if (!ui) throw new Error('invalid mocha interface "' + ui + '"');
    ui(suite);
    suite.emit('pre-require', window);
  };

  mocha.run = function () {
    suite.emit('run');
    var runner = new mocha.Runner(suite);
    var reporter = new Reporter(runner);
    var query = parse(window.location.search || "");
    if (query.grep) runner.grep(new RegExp(query.grep));
    return runner.run();
  };
})();
