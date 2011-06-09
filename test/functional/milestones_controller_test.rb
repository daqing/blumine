require 'test_helper'

class MilestonesControllerTest < ActionController::TestCase
  setup do
    log_in(:daqing)
    @project = projects(:blumine)
    @milestone = milestones(:one)
  end

  test "login required" do
    log_out
    get :new, :project_id => @project.id
    assert_response :redirect

    post :create, :project_id => @project.id, :milestone => {:name => 'foo'}
    assert_response :redirect
  end

  test "should get new" do
    get :new, :project_id => @project.id
    assert_response :success
    assert_select 'form.new_milestone'
  end

  test "should create milestone" do
    assert_difference('Milestone.count') do
      post :create, :project_id => @project.id, :milestone => {:name => 'foobar', :due_date => '2010-05-22'}
    end
    assert assigns(:project)
    assert_redirected_to project_path(assigns(:project))
  end

  test "root can get edit" do
    edit_milestone
    assert_response :success
    assert_select 'form.edit_milestone'
  end

  test "other users cannot get edit" do
    relog_in(:two)
    edit_milestone
    assert_no_permission
  end

  test "root can update milestone" do
    new_name = 'foobar'
    update_milestone(new_name)
    assert_redirected_to @project
    assert_equal new_name, assigns(:milestone).name
  end

  test "others cannot update milestone" do
    relog_in(:two)
    new_name = 'foobar'
    update_milestone(new_name)
    assert_no_permission
  end

  test "root or creator can delete milestone" do
    assert_difference('Milestone.count', -1) do
      destroy_milestone
    end
    assert_redirected_to @project
  end

  test "other users cannot delete milestone" do
    relog_in(:two)
    destroy_milestone
    assert_no_permission
  end

  private
    def edit_milestone
      get :edit, :id => @milestone.id, :project_id => @project.id
    end

    def update_milestone(new_name)
      post :update, :id => @milestone.id, :project_id => @project.id, :milestone => {:name => new_name}
    end

    def destroy_milestone
      delete :destroy, :id => @milestone.id, :project_id => @project.id
    end
end
