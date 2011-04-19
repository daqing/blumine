require 'test_helper'

class TodoItemsControllerTest < ActionController::TestCase
  setup do
    @issue = issues(:bug_report)
    @todo = todo_items(:first_todo)
    ensure_logged_in
  end

  test "should create todo" do
    assert_difference('TodoItem.count') do
      create_todo_item
    end

    assert assigns(:issue)
    assert assigns(:project)
    assert_redirected_to project_issue_path(assigns(:project), assigns(:issue))
  end

  test "should not create todo if not logged in" do
    logout
    create_todo_item
    assert_redirected_to login_path
  end

  test "should mark as done" do
    xhr :post, :change_state, :event => "finish", :id => @todo.id
    assert_response :success
    assert_equal :done, assigns(:todo_item).current_state.name
  end

  test "should mark as new" do
    @todo.finish! if @todo.open?

    xhr :post, :change_state, :event => "undo", :id => @todo.id
    assert_response :success
    assert_equal :open, assigns(:todo_item).current_state.name
  end

  test "should destroy todo via xhr" do
    assert_difference('TodoItem.count', -1) do
      xhr :delete, :destroy, :id => @todo.id
    end
    assert_response :success
  end

  test "should destroy todo normally" do
    assert_difference('TodoItem.count', -1) do
      delete :destroy, :id => @todo.id
    end

    assert assigns(:todo_item)
    assert_redirected_to [assigns(:todo_item).issue.project, assigns(:todo_item).issue]
  end

  private
    def create_todo_item
      post :create, :issue_id => @issue.id, :todo_item => { :content => @todo.content }
    end
end
