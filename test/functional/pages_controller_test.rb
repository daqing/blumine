require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success

    assert assigns(:title)
  end

  test "root path should be routed to index action" do
    assert_routing root_path, :controller => "pages", :action => "index"
  end
end
