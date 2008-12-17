require File.join(File.dirname(__FILE__), 'test_helper')

class ApplicationTest < Test::Unit::TestCase

  context "viewing the home page" do
    should "render the index view" do
      get_it '/'
      assert @response.body =~ /<!-- index.haml -->/, @response.body
    end

    should "show an email field" do
      get_it '/'
      assert @response.body =~ /<input.*name='email'/, @response.body
    end

    should "show a location field" do
      get_it '/'
      assert @response.body =~ /<input.*name='location'/, @response.body
    end
  end
end
