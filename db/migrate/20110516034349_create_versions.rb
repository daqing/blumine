class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table :versions do |t|
      t.integer :project_id
      t.integer :user_id
      t.string :name
      t.date :release_date

      t.timestamps
    end
  end

  def self.down
    drop_table :versions
  end
end
