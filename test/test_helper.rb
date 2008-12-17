require 'rubygems'

require 'test/unit'
require 'activesupport'
require 'active_support/test_case'
require 'shoulda'
require 'shoulda/active_record'
require 'mocha'

ENV['environment'] = 'test'

root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

testdb = File.join(root, 'db', 'data.test.sqlite')
File.delete(testdb) if File.exists?(testdb)

# require the sinatra app
require File.join(root, 'app')

module Test
  module Unit
    class TestCase
      # poor man's transactional fixture
      teardown :delete_everthing

      def delete_everthing
        Email.delete_all
        Location.delete_all
        Visit.delete_all
      end
    end
  end
end