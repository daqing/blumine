class AddLabelToIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :label, :string
  end

  def self.down
    remove_column :issues, :label
  end
end
