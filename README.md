# Matcha

Matcha is a Rails engine that allows you to test your JavaScript with the
[mocha](http://visionmedia.github.com/mocha/) test framework and [chai](http://chaijs.com/)
assertion library.

It is similar to [Jasmine](https://github.com/pivotal/jasmine-gem) and
[Evergreen](https://github.com/jnicklas/evergreen), but does not attempt to be framework
agnostic. By sticking with Rails, Matcha can take full advantage of features such as
the asset pipeline and engines.

## Installation

Add matcha to the `:test` and `:development` groups in the Gemfile:

    group :test, :development do
      gem "matcha"
    end

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install matcha

## Usage

Create a `spec/javascripts` directory and name the files in it with a `_spec` suffix.
You can write the specs in either JavaScript or CoffeeScript, using a `.js` or
`.js.coffee` extension respectively, like you would any other script asset.

Require the assets under test and any other dependencies using Sprockets directives.
For example, suppose you wanted to test your cool JavaScript `Array#sum` method, which
you placed in `app/assets/javascripts/array_sum.js`. Write the specs in JavaScript in
the file `spec/javascripts/array_sum_spec.js`:

    //= require array_sum

    describe("Array#sum", function(){
      it("returns 0 when the Array is empty", function(){
        [].sum().should.equal(0);
      });

      it("returns the sum of numeric elements", function(){
        [1,2,3].sum().should.equal(6);
      });
    });

Or, if you prefer CoffeeScript, in `spec/javascripts/array_sum_spec.js.coffee`:

    #= require array_sum

    describe "Array#sum", ->
      it "returns 0 when the Array is empty", ->
        [].sum().should.equal(0)

      it "returns the sum of numeric elements", ->
        [1,2,3].sum().should.equal(6)

The `matcha:server` rake task starts a server for your tests. You can go to the root
page to run all specs (e.g. `http://localhost:8888/`), or a sub page to run an individual
spec file (e.g. `http://localhost:8888/array_sum_spec`).

Alternatively, you can run the specs headlessly with the `matcha:ci` task.

## Spec Helper

Since Matcha integrates with the asset pipeline, using setup helpers in your specs is
easy. Just create a `spec_helper.js` or `spec_helper.js.coffee` file in `specs/javascripts`
and require it in your tests:

    //= require spec_helper
    //= require array_sum

    describe("Array#sum", function(){
      ...
    });

## Directives and Asset Bundling

We suggest that you explicitly require just the assets necessary for each spec. In CI
mode, Matcha will run each spec in isolation, and requiring things explicitly will help
ensure your scripts don't accumulate hidden dependencies and tight coupling.

However, you are free to ignore this advice and require the entire application.js asset
bundle in your specs or spec helper, or a bundled subset of assets. Requiring bundled
assets works like it does in Rails development mode -- Matcha will detect the complete
set of dependencies and generate a separate script tag for each one. You won't have to
search through a many thousand line application.js bundle to debug a spec failure.

## Configuration

Matcha can be configured in an initializer, e.g. `config/initializers/matcha.rb`:

    Matcha.configure do |config|
      config.spec_dir  = "spec/javascripts"
      config.interface = :bdd
      config.driver    = :selenium
    end if defined?(Matcha)

The `defined?` check is necessary to avoid a dependency on Matcha in the production
environment.

The `spec_dir` option tells Matcha where to find JavaScript specs. The `interface`
option specifies the test interface used by Mocha (see below). `driver` names a
Capybara driver used for the CI task (try `:webkit`, after installing
[capybara-webkit](https://github.com/thoughtbot/capybara-webkit)).

The values above are the defaults.

## Test Interface and Assertions

Matcha includes a vendored copy of mocha.js and the [chai](http://chaijs.com/)
assertion libraries.

By default, it will assume that you want to use Mocha's "BDD" test interface, which
provides `describe()`, `it()`, `before()`, `after()`, `beforeEach()`, and `afterEach()`.
If you want to use the TDD, Exports, or QUnit interfaces instead, set the `interface`
configuration option in an initializer:

    Matcha.configure do |config|
      config.interface = :tdd # Or :exports or :qunit
    end if defined?(Matcha)

Matcha will make all three of chai's assertion styles available to you: `expect`,
`should`, and `assert`. See the chai documentation for the details.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2012 John Firebaugh

MIT License (see the LICENSE file)

Portions: Copyright (c) 2009 Jonas Nicklas, Copyright (c) 20011-2012 TJ Holowaychuk
<tj@vision-media.ca>, Copyright (c) 2011 Jake Luer <jake@alogicalparadox.com>. See
LICENSE file for details.
