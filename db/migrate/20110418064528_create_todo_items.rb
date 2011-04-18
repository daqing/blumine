class CreateTodoItems < ActiveRecord::Migration
  def self.up
    create_table :todo_items do |t|
      t.integer :issue_id
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :todo_items
  end
end
