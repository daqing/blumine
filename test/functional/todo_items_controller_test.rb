require 'test_helper'

class TodoItemsControllerTest < ActionController::TestCase
  setup do
    @issue = issues(:bug_report)
    @todo = todo_items(:first_todo)
  end

  test "should create todo" do
    assert_difference('TodoItem.count') do
      post :create, :issue_id => @issue.id, :todo_item => { :content => @todo.content }
    end

    assert assigns(:issue)
    assert assigns(:project)
    assert_redirected_to project_issue_path(assigns(:project), assigns(:issue))
  end

  test "should mark as done" do
    xhr :get, :do_it, :id => @todo.id
    assert_response :success
    assert_equal :done, assigns(:todo_item).current_state.name
  end

  test "should mark as new" do
    @todo.do_it! if @todo.new?

    xhr :get, :undo, :id => @todo.id
    assert_response :success
    assert_equal :new, assigns(:todo_item).current_state.name
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
end
