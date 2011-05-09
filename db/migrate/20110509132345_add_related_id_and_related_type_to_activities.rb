class AddRelatedIdAndRelatedTypeToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :related_id, :integer
    add_column :activities, :related_type, :string
  end

  def self.down
    remove_column :activities, :related_type
    remove_column :activities, :related_id
  end
end
