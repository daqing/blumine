class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.integer :project_id
      t.integer :user_id
      t.string :title
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
