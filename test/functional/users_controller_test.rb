require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should recognize new_user_path" do
    assert_routing new_user_path, :controller => "users", :action => "new"
  end

end
