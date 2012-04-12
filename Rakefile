#!/usr/bin/env rake

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new :spec => :generate

desc 'Build and copy Mocha and Chai assets from submodules into vendor/assets'
task :generate do
  unless File.exist?('mocha/Makefile') && File.exist?('chai/Makefile')
    fail 'Run "git submodule update --init" to initialize the submodules'
  end
  system('(cd mocha && make -s) &&
          (cd chai && make -s)') \
      or fail('Failed to build assets')
  FileUtils.mkdir_p 'vendor/assets/javascripts'
  FileUtils.mkdir_p 'vendor/assets/stylesheets'
  FileUtils.cp 'mocha/mocha.js', 'vendor/assets/javascripts/'
  FileUtils.cp 'mocha/mocha.css', 'vendor/assets/stylesheets/'
  FileUtils.cp 'chai/chai.js', 'vendor/assets/javascripts/'
end

task :default => :spec
