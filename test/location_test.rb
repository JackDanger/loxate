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


  context "Finding existing records" do
    
    setup do
      Location.create(:nickname => 'home', :address => '615 nw 85th st, seattle, wa 98125', :coordinates => "47.6906448,-122.3644449")
      Location.create(:nickname => 'tv', :address => 'Beverly Hills, 90210', :coordinates => "34.1030032,-118.4104684")
    end
    
    should "find location when the address is a saved nickname" do
      assert_equal Location.find_by_nickname('home'), Location.find_or_create_by_user_entered_location('home')
    end

    should "find location when the address has been used before" do
      assert_equal Location.find_by_address('Beverly Hills, 90210'), Location.find_or_create_by_user_entered_location('Beverly Hills, 90210')
    end
  end

  context "creating new records" do
    setup do
      @coords = "37.4,-89.4"
      Location.stubs(:geocoordinate).returns(@coords)
    end

    should "save location with geocordinates" do
      assert_equal @coords, Location.find_or_create_by_user_entered_location("some address").coordinates
    end

    should "save location with address" do
      assert_equal 'some address', Location.find_or_create_by_user_entered_location("some address").address
    end

    should "have empty nickname if none was given" do
      assert_equal '', Location.find_or_create_by_user_entered_location("some address").nickname
    end

    should "save nickname if provided" do
      assert_equal 'work', Location.find_or_create_by_user_entered_location("some address [work]").nickname
    end

    should "save nickname, address, and coordinates when nick is given" do
      location = Location.find_or_create_by_user_entered_location("some address [work]")
      assert_equal 'work',         location.nickname
      assert_equal 'some address', location.address
      assert_equal @coords,        location.coordinates
    end
  end
end
