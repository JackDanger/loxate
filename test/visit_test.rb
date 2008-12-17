require File.join(File.dirname(__FILE__), 'test_helper')

class VisitTest < Test::Unit::TestCase

  should_belong_to :location

end