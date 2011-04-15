require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
    assert assigns(:user_session)
  end

  test "should define login and logout path" do
    assert_equal '/login', login_path
  end
end
