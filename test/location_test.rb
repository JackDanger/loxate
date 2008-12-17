require File.join(File.dirname(__FILE__), 'test_helper')

class LocationTest < Test::Unit::TestCase

  should_have_many :visits
  should_belong_to :email

  context "Parsing user entered data" do

    should "return 3 values" do
      assert_equal 3, Location.parse('').size
    end

    should "return array" do
      assert Array === Location.parse('')
    end

    should "return three blank strings if given nothing" do
      assert_equal ['', '', ''], Location.parse('')
    end

    should "extract nicknames" do
      assert_equal 'home', Location.parse('some place, ca [home]')[0]
    end

    should "separate nickname and address" do
      assert_equal ['home', 'some place, ca'], Location.parse('some place, ca [home]')[0..1]
    end

    should "recognize coordinates if given" do
      assert_equal '4.122398,-15.12212', Location.parse('4.122398,-15.12212').last
    end

    should "set the address to the coordinates if numbers were given" do
      nick, address, coordinates = Location.parse('4.122398,-15.12212')
      assert_equal address, coordinates
    end
  end

end