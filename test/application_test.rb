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
      post_it "/", "location" => "596 SW Awesome blvd, Seattle, WA", "email" => "me@myself.com"
    end

    should "render the updated view" do
      assert @response.body =~ /<!-- updated.haml -->/, @response.body
    end

    should "save the new location" do
      assert @response.body =~ /<!-- updated.haml -->/, @response.body
    end
  end

end
