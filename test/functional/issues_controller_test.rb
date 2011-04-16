require 'test_helper'

class IssuesControllerTest < ActionController::TestCase
  setup do
    @issue = issues(:bug_report)
    @project = @issue.project
    ensure_logged_in
  end

  test "project issue routing" do
    assert_generates new_project_issue_path(@project), {:controller => "issues", :action => "new", :project_id => @project.id}
  end

  test "should get new" do
    get :new, :project_id => @project.id
    assert_response :success

    assert assigns(:project)
    assert assigns(:issue)
  end

  test "should create issue" do
    assert_difference('Issue.count') do
      post :create, :project_id => @project.id, :issue => {:title => "test", :content => "foobar"}
    end

    assert_redirected_to project_issue_path(assigns(:project), assigns(:issue))
    assert_equal assigns(:issue).user_id, current_user.id
  end

  test "should get show" do
    get :show, :project_id => @project.id, :id => @issue.id
    assert_response :success
  end

  test "should get destroy" do
  end

end
