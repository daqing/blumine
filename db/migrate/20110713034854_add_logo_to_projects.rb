class AddLogoToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :logo, :string
  end

  def self.down
    remove_column :projects, :logo
  end
end
