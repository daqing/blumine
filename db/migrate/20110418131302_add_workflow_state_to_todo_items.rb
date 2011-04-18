class AddWorkflowStateToTodoItems < ActiveRecord::Migration
  def self.up
    add_column :todo_items, :workflow_state, :string
  end

  def self.down
    remove_column :todo_items, :workflow_state
  end
end
