require 'test_helper'

class TodoItemTest < ActiveSupport::TestCase
  setup do
    @todo = TodoItem.new
  end

  test "issue_id and content are required" do
    assert ! @todo.save

    @todo.issue = issues(:bug_report)
    assert ! @todo.save

    @todo.content = "to change the world"
    assert @todo.save
  end

  test "should define workflow" do
    assert_equal :open, @todo.current_state.name
    assert @todo.respond_to? :finish!
    @todo.finish!
    assert_equal :done, @todo.current_state.name

    assert @todo.respond_to? :undo!
    @todo.undo!
    assert_equal :open, @todo.current_state.name
  end
end
