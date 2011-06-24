require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:daqing)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert assigns(:user)
    assert assigns(:title)
  end

  test "should redirect to root path if already logged in" do
    log_in(:daqing)
    get :new
    assert_redirected_to root_path
  end

  test "should recognize new_user_path" do
    assert_routing register_path, :controller => "users", :action => "new"
  end

  test "should create user" do
    assert_difference('User.count') do
      @user.email = "daqing@foobar.com"
      post :create, :user => {:name => @user.name, :email => @user.email, 
        :password => "foobar", :password_confirmation => "foobar"}
    end

    assert_response :redirect
  end

  test "should get show" do
    log_in(:daqing)
    get :show, :id => users(:daqing).id

    assert_response :success
    assert assigns(:user)
    assert assigns(:title)

    assert_select '.module header h3'
  end

  test "should redirect to login path when not logged in" do
    get :show, :id => users(:daqing).id

    assert_redirected_to root_path
  end

  test "should not destroy user" do
    assert_raise(AbstractController::ActionNotFound) do
      delete :destroy, :id => users(:daqing).id
    end
  end
end
