class CreateFeatures < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
      t.integer :version_id
      t.integer :user_id
      t.string :title
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :features
  end
end
