# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["John Firebaugh"]
  gem.email         = ["john.firebaugh@gmail.com"]
  gem.summary       = %q{Unit-test your Rails JavaScript with the mocha test framework and chai assertion library}
  gem.description   = %q{Konacha is a Rails engine that allows you to test your JavaScript with the
mocha test framework and chai assertion library.

It is similar to Jasmine and Evergreen, but does not attempt to be framework
agnostic. By sticking with Rails, Konacha can take full advantage of features such as
the asset pipeline and engines.}
  gem.homepage      = "http://github.com/jfirebaugh/konacha"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "konacha"
  gem.require_paths = ["lib"]
  gem.version       = "2.1.0"
  gem.license       = "MIT"

  gem.add_dependency "railties", ">= 3.1", "< 5"
  gem.add_dependency "actionpack", ">= 3.1", "< 5"
  gem.add_dependency "sprockets"
  gem.add_dependency "capybara", "~> 2.0"
  gem.add_dependency "colorize"

  gem.add_development_dependency "jquery-rails"
  gem.add_development_dependency "rspec-rails", "~> 2.12"
  gem.add_development_dependency "capybara-firebug", "~> 1.1"
  gem.add_development_dependency "coffee-script"
  gem.add_development_dependency "ejs"
  gem.add_development_dependency "tzinfo"
end
