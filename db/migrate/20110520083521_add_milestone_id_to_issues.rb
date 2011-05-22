class AddMilestoneIdToIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :milestone_id, :integer
  end

  def self.down
    remove_column :issues, :milestone_id
  end
end
