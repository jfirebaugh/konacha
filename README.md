# Konacha

[![Build Status](https://secure.travis-ci.org/jfirebaugh/konacha.png?branch=master)](http://travis-ci.org/jfirebaugh/konacha)
[![Dependency Status](https://gemnasium.com/jfirebaugh/konacha.png)](https://gemnasium.com/jfirebaugh/konacha)

Konacha is a Rails engine that allows you to test your JavaScript with the
[mocha](http://visionmedia.github.com/mocha/) test framework and [chai](http://chaijs.com/)
assertion library.

[![Konacha][2]][1]

  [1]: http://en.wikipedia.org/wiki/Konacha
  [2]: https://github.com/jfirebaugh/konacha/raw/master/vendor/images/konacha.jpg

It is similar to [Jasmine](https://github.com/pivotal/jasmine-gem) and
[Evergreen](https://github.com/jnicklas/evergreen), but does not attempt to be framework
agnostic. By sticking with Rails, Konacha can take full advantage of features such as
the asset pipeline and engines.

Photo credit: [FCartegnie](http://commons.wikimedia.org/wiki/File:Konacha.jpg), CC-BY-SA.

## Installation

Add konacha to the `:test` and `:development` groups in the Gemfile and `bundle install`:

```ruby
group :test, :development do
  gem "konacha"
end
```

## Usage

Create a `spec/javascripts` directory and name the files in it with a `_spec`
(or `_test`) suffix. You can write the specs in either JavaScript or
CoffeeScript, using a `.js` or `.js.coffee` extension respectively, like you
would any other script asset.

Require the assets under test and any other dependencies using Sprockets directives.
For example, suppose you wanted to test your cool JavaScript `Array#sum` method, which
you placed in `app/assets/javascripts/array_sum.js`. Write the specs in JavaScript in
the file `spec/javascripts/array_sum_spec.js`:

```javascript
//= require array_sum

describe("Array#sum", function() {
  it("returns 0 when the Array is empty", function() {
    [].sum().should.equal(0);
  });

  it("returns the sum of numeric elements", function() {
    [1,2,3].sum().should.equal(6);
  });
});
```

Or, if you prefer CoffeeScript, in `spec/javascripts/array_sum_spec.js.coffee`:

```coffeescript
#= require array_sum

describe "Array#sum", ->
  it "returns 0 when the Array is empty", ->
    [].sum().should.equal(0)

  it "returns the sum of numeric elements", ->
    [1,2,3].sum().should.equal(6)
```

## Running (Rake Tasks)

### `rake konacha:serve`

The `konacha:serve` rake task starts a server for your tests. You can go to the root
page to run all specs (e.g. `http://localhost:3500/`), a sub page to run an individual
spec file (e.g. `http://localhost:3500/array_sum_spec`), or a path to a subdirectory to
run a subset of specs (e.g. `http://localhost:3500/models`).

### `rake konacha:run`

The `konacha:run` rake task will let you run your tests from the command line.

To an individual spec, or specs, you can pass a comma seperated list of specs via the `SPEC` parameter

```
$ rake konacha:run SPEC=foo_spec
$ rake konacha:run SPEC=foo_spec,bar_spec,etc_spec
```

## Spec Helper

Since Konacha integrates with the asset pipeline, using setup helpers in your specs is
easy. Just create a `spec_helper.js` or `spec_helper.js.coffee` file in `specs/javascripts`
and require it in your tests:

```javascript
//= require spec_helper
//= require array_sum

describe("Array#sum", function() {
  ...
});
```

## Directives and Asset Bundling

We suggest that you explicitly require just the assets necessary for each spec. In CI
mode, Konacha will run each spec in isolation, and requiring things explicitly will help
ensure your scripts don't accumulate hidden dependencies and tight coupling.

However, you are free to ignore this advice and require the entire application.js asset
bundle in your specs or spec helper, or a bundled subset of assets. Requiring bundled
assets works like it does in Rails development mode -- Konacha will detect the complete
set of dependencies and generate a separate script tag for each one. You won't have to
search through a many thousand line application.js bundle to debug a spec failure.

## Configuration

Konacha can be configured in an initializer, e.g. `config/initializers/konacha.rb`:

```ruby
Konacha.configure do |config|
  config.spec_dir  = "spec/javascripts"
  config.driver    = :selenium
end if defined?(Konacha)
```

The `defined?` check is necessary to avoid a dependency on Konacha in the production
environment.

The `spec_dir` option tells Konacha where to find JavaScript specs. `driver` names a
Capybara driver used for the `run` task (try `:webkit`, after installing
[capybara-webkit](https://github.com/thoughtbot/capybara-webkit)).

The values above are the defaults.

### Mocha Configuration

You can customize the Mocha options passed into `mocha.setup(..)` by creating a file
named `konacha_config.js` or `konacha_config.js.coffee` in `spec/javascripts` and
setting properties of `Konacha.mochaOptions`:

```javascript
// ignore the following globals during leak detection
Konacha.mochaOptions.globals = ['YUI'];

// or, ignore all leaks
Konacha.mochaOptions.ignoreLeaks = true;

// set slow test timeout in ms
Konacha.mochaOptions.timeout = 5;
```

The `ui` and `reporter` Mocha options are set by Konacha and must not be modified.

## Test Interface and Assertions

Konacha includes a vendored copy of mocha.js and the [chai](http://chaijs.com/)
assertion libraries. It configures Mocha to use the "BDD" test interface, which
provides `describe()`, `it()`, `before()`, `after()`, `beforeEach()`, and `afterEach()`.

Konacha will make all three of chai's assertion styles available to you: `expect`,
`should`, and `assert`. See the chai documentation for the details.

If you use jQuery, you may want to check out [chai-jquery](https://github.com/jfirebaugh/chai-jquery)
for some jQuery-specific assertions.

## Transactions

One problem often faced when writing unit tests for client side code is that changes
to the page are not reverted for the next example, so that successive examples become
dependent on each other. Konacha adds a special div to your page with an id of `konacha`.
This div is automatically emptied before each example. You should avoid appending markup
to the page body and instead append it to the `#konacha` div:

```coffeescript
describe "transactions", ->
  it "should add stuff in one test...", ->
    $('#konacha').append('<h1 id="added">New Stuff</h1>')
    $('#konacha h1#added').length.should.equal(1)

  it "... should have been removed before the next starts", ->
    $('#konacha h1#added').length.should.equal(0)
```

## Templates / Fixtures

Konacha has no template (a.k.a. HTML fixture) support of its own. Instead, we suggest you use
Sprocket's built in support for JavaScript template (`.jst`) files. Add a `spec/javascripts/templates`
directory, place template files there (using any JS template language supported by Sprockets),
require them in your spec or spec_helper, and render them into the `#konacha` div.

For example, in `spec/javascripts/templates/hello.jst.ejs`:

```html
<h1>Hello Konacha!</h1>
```

In `spec_helper.js`:

```javascript
//= require_tree ./templates
```

And your spec:

```javascript
//= require spec_helper

describe("templating", function() {
  it("is built in to Sprockets", function() {
    $('#konacha').html(JST['templates/hello']());
    $('#konacha h1').text().should.equal('Hello Konacha!');
  });
});
```

## Contributing

```bash
git clone git://github.com/jfirebaugh/konacha.git
```

Run `bundle exec rake` to run the test suite.

### Contributing to Mocha and Chai

The Konacha repository includes the
[Mocha](https://github.com/visionmedia/mocha) and
[Chai](https://github.com/chaijs/chai) repositories as submodules, so
you can hack on them directly:

```bash
cd mocha # or: cd chai
git checkout master
... hack-hack-hack ...
bundle exec rake assets # make and cp assets based on your changes
```

Assuming your app's Gemfile points at your Konacha checkout (`gem 'konacha',
:path => '~/path/to/konacha'`), your changes to Mocha and Chai are live in
localhost:3500 when you refresh your browser.

You can send pull requests to Mocha and Chai straight out of your submodules.

## License

Copyright (c) 2012 John Firebaugh

MIT License (see the LICENSE file)

Portions: Copyright (c) 2009 Jonas Nicklas, Copyright (c) 20011-2012 TJ Holowaychuk
<tj@vision-media.ca>, Copyright (c) 2011 Jake Luer <jake@alogicalparadox.com>. See
LICENSE file for details.
