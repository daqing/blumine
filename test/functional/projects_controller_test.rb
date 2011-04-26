require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    ensure_logged_in
  end
  
  test "should get new" do
    get :new, :user_id => current_user.id
    assert_response :success

    assert assigns(:project)
    assert assigns(:title)
  end

  test "should create project" do
    assert_difference('Project.count') do
      create_project
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should get show" do
    get :show, :id => projects(:blumine).id
    assert_response :success

    assert assigns(:title)
  end

  test "should get index" do
    get :index

    assert_response :success
    assert assigns(:projects)
    assert assigns(:title)
  end

  test "should redirect to login path if get index" do
    logout
    get :index

    assert_redirected_to login_path
  end

  test "should not create project if not logged in" do
    logout
    create_project
    assert_redirected_to login_path
  end

  private
    def create_project
      post :create, :project => {:name => "demo project"}
    end
end
