require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    log_in(:daqing)
  end
  
  test "should get new" do
    get :new, :user_id => current_user.id
    assert_response :success

    assert assigns(:project)
    assert assigns(:title)

    assert_select 'form.new_project'
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
    assert assigns(:project)
  end

  test "should get index" do
    get :index

    assert_response :success
    assert assigns(:projects)
    assert assigns(:title)
  end

  test "should redirect to login path if get index" do
    log_out
    get :index

    assert_redirected_to root_path
  end

  test "should not create project if not logged in" do
    log_out
    create_project
    assert_redirected_to root_path
  end

  test "should create activity after a project is created" do
    assert_difference('Activity.count') do
      create_project
    end
  end

  test "root can delete projects" do
    assert_difference('Project.count', -1) do
      delete :destroy, :id => projects(:blumine).id
    end
    assert_redirected_to root_path
  end

  test "other users cannot delete project" do
    log_out
    log_in(:two)
    delete :destroy, :id => projects(:blumine).id
    assert_no_permission
  end

  private
    def create_project
      post :create, :project => {:name => "demo project"}
    end
end
