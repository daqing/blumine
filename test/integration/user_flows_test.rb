require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  # fixtures :all

  test "register, logout and login" do
    # register
    get "/"
    assert_response :success

    get "/users/new"
    assert_response :success

    post "/users", :user => {:name => "foobar",
      :email => "foobar@demo.com", :password => "help",
      :password_confirmation => "help"}

    assert_redirected_to root_path
    follow_redirect!

    # log out
    get '/logout'
    assert_redirected_to root_path

    follow_redirect!
    assert_equal "您已经成功退出。", flash[:notice]

    # login again
    get "/login"
    assert_response :success

    post "/user_sessions", :user_session => {:email => "foobar@demo.com", :password => "help"}
    assert_redirected_to root_path
  end
end
