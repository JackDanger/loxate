require 'rubygems'

require 'test/unit'
require 'shoulda'
require 'shoulda/active_record'
require 'mocha'

ENV['environment'] = 'test'

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

testdb = File.join(root, 'db', 'data.test.sqlite')
File.delete(testdb) if File.exists?(testdb)

# require the sinatra app
require File.join(root, 'app')
# and the sinatra tests
require File.join(root, 'vendor/sinatra/lib/sinatra/test/unit')
