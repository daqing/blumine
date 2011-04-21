class CreateStatusLogs < ActiveRecord::Migration
  def self.up
    create_table :status_logs do |t|
      t.integer :user_id
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :status_logs
  end
end
