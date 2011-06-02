class UpdateActivity < ActiveRecord::Migration
  def self.up
    change_table :activities do |t|
      t.remove :target_type, :related_id, :related_type
      t.integer :project_id
    end
  end

  def self.down
    change_table :activities do |t|
      t.string :target_type
      t.string :related_type
      t.integer :related_id
      t.remove :project_id
    end
  end
end
