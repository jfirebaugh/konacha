# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["John Firebaugh"]
  gem.email         = ["john.firebaugh@gmail.com"]
  gem.description   = %q{Unit test your Rails JavaScript with the mocha test framework and chai assertion library}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "http://github.com/jfirebaugh/matcha"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "matcha"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.1"

  gem.add_dependency "jquery-rails"
  gem.add_dependency "rails", "~> 3.1"
  gem.add_dependency "capybara"

  gem.add_development_dependency "rspec-rails"
  gem.add_development_dependency "capybara-firebug", "~> 1.1"
  gem.add_development_dependency "coffee-script"
  gem.add_development_dependency "ejs"
end
