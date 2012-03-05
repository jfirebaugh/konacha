ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rspec/rails"
require "rspec/autorun"

# Preload to avoid occasional tilt warnings about thread safety
require "coffee_script"
require "ejs"

require "capybara/rails"
require "capybara/firebug"

Capybara.configure do |config|
  config.default_selector = :css
  config.default_driver   = :selenium_with_firebug
  config.app              = Konacha.application
end
