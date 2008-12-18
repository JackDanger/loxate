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
    
    context "with valid data" do
      setup do
        @address = "596 SW Awesome blvd, Seattle, WA"
        @email   = "me@myself.com"
        post_it "/", "location" => @address, "email" => @email
      end

      before_should "hit the right layout" do
        Sinatra::EventContext.any_instance.expects(:render).with(:haml, :updated, :layout => :default).once
      end

      should "render the updated view" do
        assert @response.body =~ /<!-- updated.haml -->/
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
    
    context "with invalid data" do

      should "render home page if location is empty" do
        Sinatra::EventContext.any_instance.expects(:render).with(:haml, :index, :layout => :default).once
        post_it '/', "location" => "90210", "email" => ""
      end

      should "render home page if email is empty" do
        Sinatra::EventContext.any_instance.expects(:render).with(:haml, :index, :layout => :default).once
        post_it '/', "location" => "", "email" => "fullemail@signup.com"
      end

      should "render home page if email is invalid" do
        Sinatra::EventContext.any_instance.expects(:render).with(:haml, :index, :layout => :default).once
        post_it '/', "location" => "", "email" => "fullemail@signup.com"
      end

      should "render home page if location and email are empty" do
        Sinatra::EventContext.any_instance.expects(:render).with(:haml, :index, :layout => :default).once
        post_it '/', "location" => "", "email" => ""
      end

      should_eventually "display error for missing email" do
      end

      should_eventually "display error for missing location" do
      end

      should_eventually "autofill with passed data" do
      end
      
      context "when token is required" do

        should_eventually "display token field" do
        end

        should_eventually "display token explanation" do
        end

      end
    end
  end

end
