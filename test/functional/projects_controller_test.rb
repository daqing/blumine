require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    ensure_logged_in
  end
  
  test "should get new" do
    get :new, :user_id => current_user.id
    assert_response :success

    assert assigns(:project)
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, :project => {:name => "demo project"}
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should get show" do
    get :show, :id => projects(:one).id
    assert_response :success
  end

  test "should get index" do
    get :index

    assert_response :success
    assert assigns(:projects)
  end
end
