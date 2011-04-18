require 'test_helper'

class TodoItemsControllerTest < ActionController::TestCase
  setup do
    @issue = issues(:bug_report)
  end

  test "should create todo" do
    assert_difference('TodoItem.count') do
      post :create, :issue_id => @issue.id, :todo_item => {:content => "to change the world"}
    end

    assert assigns(:issue)
    assert assigns(:project)
    assert_redirected_to project_issue_path(assigns(:project), assigns(:issue))
  end
end
