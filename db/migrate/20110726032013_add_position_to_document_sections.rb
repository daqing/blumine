class AddPositionToDocumentSections < ActiveRecord::Migration
  def self.up
    add_column :document_sections, :position, :integer
  end

  def self.down
    remove_column :document_sections, :position
  end
end
