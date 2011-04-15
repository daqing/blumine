require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
    assert assigns(:user_session)
  end

  test "should define login and logout path" do
    assert_generates login_path, :controller => "user_sessions", :action => "new"
    assert_generates logout_path, :controller => "user_sessions", :action => "destroy"
  end
end
