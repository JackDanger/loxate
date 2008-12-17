require 'rubygems'

gem 'thoughtbot-shoulda'
require 'shoulda'
require 'shoulda/active_record'
require 'test/unit'
require 'mocha'

ENV['environment'] = 'test'

testdb = File.join(File.dirname(__FILE__), '..', 'db', 'data.test.sqlite')
File.delete(testdb) if File.exists?(testdb)
require File.join(File.dirname(__FILE__), '..', 'db', 'load')
