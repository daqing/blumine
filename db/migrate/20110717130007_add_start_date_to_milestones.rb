class AddStartDateToMilestones < ActiveRecord::Migration
  def self.up
    add_column :milestones, :start_date, :date
  end

  def self.down
    remove_column :milestones, :start_date
  end
end
