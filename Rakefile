#!/usr/bin/env ruby
require 'rake'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t| 
  t.libs << "test"
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end