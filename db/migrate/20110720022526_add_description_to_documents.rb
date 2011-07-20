class AddDescriptionToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :description, :string
  end

  def self.down
    remove_column :documents, :description
  end
end
