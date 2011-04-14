require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "root path should be routed to index action" do
    assert_routing '/', :controller => "pages", :action => "index"
  end

  test "show login form on root path" do
    get :index
    assert_select "title", "Login - Blumine"
  end
end
