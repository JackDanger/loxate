require File.join(File.dirname(__FILE__), 'test_helper')

class LocationTest < Test::Unit::TestCase

  should_have_many :visits
  should_belong_to :email

end