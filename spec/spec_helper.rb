ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rspec/rails"
require "rspec/autorun"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }

require "capybara/rails"
require "capybara/firebug"

Capybara.configure do |config|
  config.default_selector = :css
  config.default_driver   = :selenium_with_firebug
  config.app              = Konacha.application
end
