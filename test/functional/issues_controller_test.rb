require 'test_helper'

class IssuesControllerTest < ActionController::TestCase
  setup do
    @issue = issues(:bug_report)
    @project = @issue.project
    log_in(:daqing)
  end

  test "project issue routing" do
    assert_generates new_project_issue_path(@project), {:controller => "issues", :action => "new", :project_id => @project.id}
  end

  test "should get new" do
    get :new, :project_id => @project.id, :label => 'task'
    assert_response :success

    assert assigns(:project)
    assert assigns(:issue)
    assert assigns(:title)
    assert assigns(:label)
  end

  test "should create issue" do
    assert_difference('Issue.count') do
      create_issue
    end

    assert_redirected_to assigns(:issue)
    assert_equal assigns(:issue).user_id, current_user.id
  end

  test "should not create issue if logged out" do
    log_out
    create_issue
    assert_redirected_to root_path
  end

  test "should not show issue if logged out" do
    log_out
    get :show, :project_id => @project.id, :id => @issue.id

    assert_redirected_to root_path
  end

  test "should get show" do
    get :show, :id => @issue.id
    assert_response :success

    assert assigns(:issue)
    assert assigns(:comment)
    assert assigns(:todo_item)
    assert assigns(:title)

    assert_select ".module header h3"
    assert_select "#todo_list_box"
    assert_select "div#issue_comments"
    assert_select "div#add_comment_form"
    assert_select "article#issue_workflow_box"
    assert_select "article#issue_assignment"
  end

  test "should change workflow state" do
    close_issue 
    assert_response :success
    assert_equal :closed, assigns(:issue).current_state.name
  end

  test "should save with default content" do
    issue = Issue.new(:title => "foobar")
    issue.project = projects(:blumine)
    issue.user = users(:daqing)

    assert issue.save
    assert_equal issue.content, issue.default_content
  end

  test "should edit issue" do
    get :edit, :id => @issue.id

    assert_response :success
    assert assigns(:title)

    assert_select 'form.edit_issue'
  end

  test "should update issue" do
    post :update, :id => @issue.id, :issue => { :content => issues(:two).content }

    assert assigns(:issue)
    assert_redirected_to issue_path(assigns(:issue))
    assert_equal issues(:two).content, assigns(:issue).content
  end

  test "should destroy issue" do
    delete :destroy, :id => @issue.id

    assert_redirected_to project_path(assigns(:issue).project)
  end

  test "only creator can edit, update or destroy issue when issue is not closed" do
    get :edit, :id => issues(:two).id
    assert_redirected_to root_path

    post :update, :id => issues(:two).id, :issue => {:content => issues(:bug_report).content}
    assert_redirected_to root_path

    delete :destroy, :id => issues(:two).id
    assert_redirected_to root_path

    @issue.close!
    get :edit, :id => @issue.id
    assert flash[:notice]
    assert_redirected_to root_path
  end

  test "should be assigned to an user" do
    assign_issue

    assert_response :success
    assert_equal assigns(:issue).assigned_user, users(:daqing)
  end

  test "only root can rebuild indexes" do
    get :rebuild_index

    assert_redirected_to root_path
  end

  test "should create activity after an issue created" do
    assert_difference('Activity.count') do
      create_issue
    end
  end

  test "should create activity after an issue is (re)assigned" do
    assert_difference('Activity.count') do
      assign_issue
    end
  end

  test "should create activity after issue workflow's changed" do
    assert_difference('Activity.count') do
      close_issue 
    end
  end

  test "should search issues" do
    get :search, :keyword => 'foo'

    assert_response :success
    assert_select '.module header h3'
  end

  test "should get autocomplete" do
    xhr :get, :autocomplete
    assert_response :success
  end

  private
    def create_issue
      post :create, :project_id => @project.id, :issue => {:title => "test", :content => "foobar"}
    end

    def assign_issue
      xhr :post, :assign_to, :id => @issue.id, :user_id => users(:daqing).id
    end

    def close_issue 
      xhr :post, :change_state, :event => :close, :id => @issue.id
    end

end
