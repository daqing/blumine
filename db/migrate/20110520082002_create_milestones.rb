class CreateMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
      t.integer :project_id
      t.string :name
      t.date :due_date

      t.timestamps
    end
  end

  def self.down
    drop_table :milestones
  end
end
