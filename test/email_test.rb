require File.join(File.dirname(__FILE__), 'test_helper')

class EmailTest < Test::Unit::TestCase

  def setup
    Location.stubs(:geocoordinate).returns("7.12312,-12.98123144")
    @email = Email.create(:name => "excellent@testworthy.com")
  end

  should_have_many :locations
  should_have_one  :location

  should_require_attributes        :name, :message => /Please enter your email address/
  should_require_unique_attributes :name, :message => /That email address is already being used/
  should_have_readonly_attributes  :name
  should_not_allow_values_for :name, 'what', 'empty@', 'domain.com', '@something.com', 'wow... what@email.com', :message => /Please enter your real email address/
  should_allow_values_for     :name, 'email@example.com', 'complex+name_code-list@uk.gov.att-company.co.au'

  context "Email.locate!" do
    
    setup do
      @email.locate!("best town, USA")
    end
    
    before_should "start with no locations" do
      assert @email.locations.blank?
    end
    
    should "save just one location record" do
      assert_equal 1, @email.locations.count
    end
    
    should "set it's own location record" do
      assert @email.location
    end
    
    should "have the location available in two places" do
      assert_equal @email.location, @email.locations.first
    end
  end

end
