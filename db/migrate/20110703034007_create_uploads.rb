class CreateUploads < ActiveRecord::Migration
  def self.up
    create_table :uploads do |t|
      t.integer :project_id
      t.integer :reply_id
      t.string :asset
      t.integer :file_size
      t.string :content_type

      t.timestamps
    end
  end

  def self.down
    drop_table :uploads
  end
end
