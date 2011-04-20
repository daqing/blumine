class AddPositionToTodoItems < ActiveRecord::Migration
  def self.up
    add_column :todo_items, :position, :integer
  end

  def self.down
    remove_column :todo_items, :position
  end
end
