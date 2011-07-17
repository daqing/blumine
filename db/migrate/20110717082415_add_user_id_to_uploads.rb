class AddUserIdToUploads < ActiveRecord::Migration
  def self.up
    add_column :uploads, :user_id, :integer
  end

  def self.down
    remove_column :uploads, :user_id
  end
end
