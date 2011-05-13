require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
    assert assigns(:title)
  end

  test "should redirect to root path if already logged in" do
    log_in(:daqing)
    get :new
    assert_redirected_to root_path
  end

  test "should define login and log_out path" do
    assert_generates login_path, :controller => "user_sessions", :action => "new"
    assert_generates logout_path, :controller => "user_sessions", :action => "destroy"
  end
end
