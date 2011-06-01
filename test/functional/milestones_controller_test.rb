require 'test_helper'

class MilestonesControllerTest < ActionController::TestCase
  setup do
    log_in(:daqing)
    @project = projects(:blumine)
    @milestone = milestones(:one)
  end

  test "login required" do
    log_out
    get :new
    assert_response :redirect

    post :create
    assert_response :redirect
  end

  test "should get new" do
    get :new, :project_id => @project.id
    assert_response :success
    assert_select 'form.new_milestone'
  end

  test "should get create" do
    assert_difference('Milestone.count') do
      post :create, :project_id => @project.id, :milestone => {:name => 'foobar', :due_date => '2010-05-22'}
    end
    assert assigns(:project)
    assert_redirected_to project_path(assigns(:project))
  end

  test "root can delete milestone" do
    assert_difference('Milestone.count', -1) do
      post :destroy, :id => @milestone.id, :project_id => @project.id
    end
    assert_redirected_to @project
  end

  test "other users cannot delete milestone" do
    relog_in(:two)
    post :destroy, :id => @milestone.id, :project_id => @project.id
    assert flash[:error]
  end
end
