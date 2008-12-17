require File.join(File.dirname(__FILE__), 'test_helper')

class ApplicationTest < Test::Unit::TestCase

  context "viewing the home page" do
    should "renders the index view" do
      get_it '/'
      assert @response.body =~ /<!-- index.haml -->/
    end
  end
end
