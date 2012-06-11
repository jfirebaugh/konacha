# master

* `rake konacha:run` exits with exit code 1 when spec suite fails

# 1.2.4

* Loosen up Rails dependency
* Fix crash when `#konacha` element is removed in test

# 1.2.3

* Update mocha (1.1.0) and chai (1.0.4)
* Traverse symlinked directories when discovering specs

# 1.2.2

* Update chai (1.0.3)
* Improve compatibility with WebKit driver
* Improve error reporting

# 1.2.1

* Update chai (1.0.1)

# 1.2.0

* Update mocha (1.0.3) and chai (1.0.0)
* Find files ending in `_test.*` as well as `_spec.*`
* Fix vendor files for adding konacha through git with bundler

# 1.1.3

* Update mocha (1.0.1) and chai (0.5.3)

# 1.1.2

* Fix asset deduplication on sprockets < 2.1

# 1.1.1

* 1.8.7 compatibility

# 1.1.0

* Provided the ability to set mocha options via JS

# 1.0.0

* Do not time out after 300 seconds
* Rename #test div to #konacha
* Update vendored copies of mocha (1.0.0+) and chai (0.5.2+)
* jQuery is no longer included by default
* Fully remove and replace the #konacha element (#23)
* Remove the `interface` configuration option. A future version will support
  all Mocha configuration options, but configuration will be done in JS, not Ruby.

# 0.10.0

* Rename `konacha:ci` and `konacha:server` task to `konacha:run` and
  `konacha:serve`
* Really don't require spec dependencies multiple times (#3)

# 0.9.1

* Support foo_spec.coffee files (without .js)
* Switch default port to 3500 to avoid collisions with HTTP proxies (like Charles)
* Update vendored copies of mocha (0.14.0+) and chai (0.4.2+)
* Do not require spec dependencies multiple times (#3)
* Support running a subset of specs via a subdirectory path
* Move #test div off screen: It's still layouted and CSS-visible,
  but not actually visible in the browser window

# 0.9.0

* Initial release
