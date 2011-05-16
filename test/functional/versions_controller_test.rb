require 'test_helper'

class VersionsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:blumine)
    log_in(:daqing)
  end

  test "user must login first to manage versions" do
    log_out
    get :index, :project_id => @project.id
    assert_response :redirect
  end
  
  test "should get index" do
    get :index, :project_id => @project.id
    assert_response :success
  end

  test "should get new" do
    get :new, :project_id => @project.id

    assert_response :success
    assert_select 'form.new_version'
  end
end
