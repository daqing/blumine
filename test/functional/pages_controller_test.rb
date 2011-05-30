require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success

    assert assigns(:title)
    assert assigns(:user_session)

    assert_select "form.new_user_session"
  end

  test "user logged in should see dashboard" do
    log_in(:daqing)
    get :index
    assert_response :success
    assert_select "form.new_activity"
  end

  test "root path should be routed to index action" do
    assert_routing root_path, :controller => "pages", :action => "index"
  end

  test "only user who has logged in can see the search & shortcut bar" do
    log_in(:daqing)
    get :index
    assert_equal 1, css_select('input#search').size
  end

  test "user logged out should not see the search & shortcut bar" do
    get :index
    assert_equal 0, css_select('#search').size
    assert_equal 0, css_select('#shortcut').size
  end

  test "only logged-in users can view stats page" do
    get :stats
    assert_response :redirect
  end

  test "should get stats page" do
    log_in(:daqing)
    get :stats
    assert_response :success
    assert_select '.module header h3'
  end
end
