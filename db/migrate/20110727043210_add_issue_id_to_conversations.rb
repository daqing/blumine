class AddIssueIdToConversations < ActiveRecord::Migration
  def self.up
    add_column :conversations, :issue_id, :integer
  end

  def self.down
    remove_column :conversations, :issue_id
  end
end
