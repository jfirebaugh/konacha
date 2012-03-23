# master

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
