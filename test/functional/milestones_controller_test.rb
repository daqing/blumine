require 'test_helper'

class MilestonesControllerTest < ActionController::TestCase
  setup do
    log_in(:daqing)
    @project = projects(:blumine)
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

end
