class CreateDocumentSections < ActiveRecord::Migration
  def self.up
    create_table :document_sections do |t|
      t.integer :document_id
      t.string :title
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :document_sections
  end
end
