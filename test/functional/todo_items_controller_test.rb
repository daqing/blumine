require 'test_helper'

class TodoItemsControllerTest < ActionController::TestCase
  setup do
    @issue = issues(:bug_report)
    @todo = todo_items(:first_todo)
    log_in(:daqing)
    @issue.assigned_user = users(:daqing)
  end

  test "should create todo" do
    assert_difference('TodoItem.count') do
      create_todo_item
    end

    assert assigns(:issue)
    assert_redirected_to assigns(:issue)
  end

  test "should not create todo if not logged in" do
    log_out
    create_todo_item
    assert_redirected_to root_path
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
    assert_redirected_to assigns(:todo_item).issue
  end
  
  test "should sort todo items" do
    relog_in(:two)
    issue = issues(:two)
    issue.assigned_user = users(:two)
    todo_ids = []
    3.times { todo_ids << issue.todo_items.create!(:content => 'foo').id }
    
    xhr :post, :sort, :todo => todo_ids
    assert_response :success
  end
  
  test "others cannot sort todo items" do
    relog_in(:nana)
    
    issue = issues(:two)
    issue.assigned_user = users(:two)
    todo_ids = []
    3.times { todo_ids << issue.todo_items.create!(:content => 'foo').id }
    xhr :post, :sort, :todo => todo_ids
    assert_no_permission
  end

  private
    def create_todo_item
      post :create, :issue_id => @issue.id, :todo_item => { :content => @todo.content }
    end
end
