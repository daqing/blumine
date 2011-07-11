class AddMoreFieldsToAccount < ActiveRecord::Migration
  def self.up
    add_column :users, :phone, :string
    add_column :users, :address, :string
    add_column :users, :im, :string
  end

  def self.down
    remove_column :users, :phone
    remove_column :users, :address
    remove_column :users, :im
  end
end
