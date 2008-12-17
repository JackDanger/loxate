require File.join(File.dirname(__FILE__), 'test_helper')

class VisitTest < Test::Unit::TestCase
  should_belong_to :location

  def test_something
    assert true
  end
end