require 'rubygems'

gem 'thoughtbot-shoulda'
require 'shoulda'
require 'shoulda/active_record'

ENV['environment'] = 'testing'

require File.join(File.dirname(__FILE__), '..', 'db', 'load')

