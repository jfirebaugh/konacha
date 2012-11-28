# In a real-world app, `rake konacha:serve` and `rake konacha:run` will use
# the development environment, so we test with the development defaults.
# In particular, it is important to test with `config.assets.debug = true`.
ENV["RAILS_ENV"] = "development"

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

module Konacha
  module FeatureSpec
    def app
      # Override the RSpec default of `Rails.application`.
      Konacha.application
    end
  end
end

RSpec.configure do |config|
  config.include Konacha::FeatureSpec, :type => :feature
end

Konacha.configure do |config|
  # We don't have an application.css in our dummy app.
  config.stylesheets = []
end
