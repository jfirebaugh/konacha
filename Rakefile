#!/usr/bin/env rake

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new :spec

desc 'Build and copy Mocha and Chai assets from submodules into vendor/assets'
task :assets do
  sh 'git submodule update --init' unless File.exist?('mocha/Makefile') || File.exist?('chai/Makefile')
  sh 'cd mocha && npm install && make clean && make'
  sh 'cd chai && npm install && make clean && make'
  mkdir_p 'vendor/assets/javascripts'
  mkdir_p 'vendor/assets/stylesheets'
  cp 'mocha/mocha.js',  'vendor/assets/javascripts/'
  cp 'mocha/mocha.css', 'vendor/assets/stylesheets/'
  cp 'chai/chai.js',    'vendor/assets/javascripts/'
end

task :default => :spec

task :server do
  sh 'rackup -p 3500 config.ru'
end
