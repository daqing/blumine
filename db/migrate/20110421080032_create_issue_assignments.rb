class CreateIssueAssignments < ActiveRecord::Migration
  def self.up
    create_table :issue_assignments do |t|
      t.integer :issue_id
      t.integer :user_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :issue_assignments
  end
end
