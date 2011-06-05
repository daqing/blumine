class AddPlannedDateToIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :planned_date, :date
  end

  def self.down
    remove_column :issues, :planned_date
  end
end
