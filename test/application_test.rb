require File.join(File.dirname(__FILE__), 'test_helper')

class ApplicationTest < Test::Unit::TestCase

  context "viewing the home page" do
    
    setup do
      get_it '/'
    end
    
    should "render the index view" do
      assert @response.body =~ /<!-- index.haml -->/, @response.body
    end

    should "show an email field" do
      assert @response.body =~ /<input.*name='email'/, @response.body
    end

    should "show a location field" do
      assert @response.body =~ /<input.*name='location'/, @response.body
    end

    should "have a form pointing to /" do
      assert @response.body =~ /<form.*action='\/'/, @response.body
    end
  end

  context "submitting the home page" do
    
    setup do
      @address = "596 SW Awesome blvd, Seattle, WA"
      post_it "/", "location" => @address, "email" => "me@myself.com"
    end

    should "render the updated view" do
      assert @response.body =~ /<!-- updated.haml -->/, @response.body
    end

    should "save a location record" do
      assert Location.first
    end

    should "save the new location to the email address" do
      assert_equal Location.first, Email.first.location
    end

    should "save the new location with the right address" do
      assert_equal @address, Email.first.location.address
    end
  end

end
