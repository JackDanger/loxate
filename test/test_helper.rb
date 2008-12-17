require 'rubygems'

gem 'thoughtbot-shoulda'
require 'shoulda'
require 'shoulda/active_record'
require 'test/unit'

ENV['environment'] = 'testing'

require File.join(File.dirname(__FILE__), '..', 'db', 'load')
