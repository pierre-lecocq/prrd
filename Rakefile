#!/usr/bin/env ruby

# File: Rakefile
# Time-stamp: <2014-09-22 22:45:18 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Rakefile for PRRD library

task :default => :help
# rake help
task :help do
  puts 'PRRD - rrdtool ruby interface'
  puts "\n" + 'Available rake tasks:'
  puts ' * test: run rspec tests'
  puts ' * code: run rubocop to verify code quality'
  puts ' * doc: run yard to generate documentation'
end

# rake test
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:test)

# rake code
require 'rubocop/rake_task'
desc 'Run RuboCop on the lib directory'
RuboCop::RakeTask.new(:code) do |task|
  task.patterns = ['lib/**/*.rb']
  task.fail_on_error = false
end

# rake doc
require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
end
task :doc => :yard
