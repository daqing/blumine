require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  # fixtures :all

  test "register, logout and login" do
    # register
    get "/"
    assert_response :success

    get "/users/new"
    assert_response :success

    register_as_foobar
    assert_response :redirect
    follow_redirect!

    # log out
    get '/logout'
    assert_redirected_to root_path

    follow_redirect!
    assert_response :success
    assert flash[:notice]

    auth_as_foobar
    assert_response :redirect

    follow_redirect!
    assert_response :success
  end
end
