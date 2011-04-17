require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:daqing)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert assigns(:user)
  end

  test "should recognize new_user_path" do
    assert_routing new_user_path, :controller => "users", :action => "new"
  end

  test "should create user" do
    assert_difference('User.count') do
      @user.email = "daqing@foobar.com"
      post :create, :user => {:name => @user.name, :email => @user.email, 
        :password => "foobar", :password_confirmation => "foobar"}
    end

    assert_redirected_to root_path
  end

  test "should get show" do
    get :show, :id => users(:daqing).id

    assert_response :success
    assert assigns(:user)
  end
end
