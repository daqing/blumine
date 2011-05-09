class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :user_id
      t.string :event_name
      t.string :target_type
      t.integer :target_id
      t.text :data

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
