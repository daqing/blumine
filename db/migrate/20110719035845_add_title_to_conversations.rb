class AddTitleToConversations < ActiveRecord::Migration
  def self.up
    add_column :conversations, :title, :string
  end

  def self.down
    remove_column :conversations, :title
  end
end
