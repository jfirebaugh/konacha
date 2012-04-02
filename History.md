# master

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
