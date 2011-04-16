class CreateIssues < ActiveRecord::Migration
  def self.up
    create_table :issues do |t|
      t.integer :project_id
      t.string :title
      t.text :content
      t.string :workflow_state

      t.timestamps
    end
  end

  def self.down
    drop_table :issues
  end
end
