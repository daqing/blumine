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

  test "should mark as done" do
    get :do_it, :id => todo_items(:first_todo).id
    assert_response :success

    assert_equal :done, assigns(:todo_item).current_state.name
  end

  test "should mark as new" do
    todo = todo_items(:first_todo)
    todo.do_it! if todo.new?

    get :undo, :id => todo.id
    assert_response :success

    assert_equal :new, assigns(:todo_item).current_state.name
  end
end
