require 'test_helper'

class TodoItemTest < ActiveSupport::TestCase
  test "issue_id and content are required" do
    todo = TodoItem.new
    assert ! todo.save

    todo.issue = issues(:bug_report)
    assert ! todo.save

    todo.content = "to change the world"
    assert todo.save
  end
end
