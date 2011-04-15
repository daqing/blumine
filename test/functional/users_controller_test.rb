require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
    assert assigns(:user)
  end

  test "should recognize new_user_path" do
    assert_routing new_user_path, :controller => "users", :action => "new"
  end

  test "should create user" do
    post :create, :user => {:name => "daqing", :email => "daqing@demo.com",
      :password => "foobar", :password_confirmation => "foobar"}

    assert_redirected_to root_path
  end

end
