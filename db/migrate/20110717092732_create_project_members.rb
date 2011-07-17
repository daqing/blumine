class CreateProjectMembers < ActiveRecord::Migration
  def self.up
    create_table :project_members do |t|
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :project_members
  end
end
