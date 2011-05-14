class CreateIssueStatusLogs < ActiveRecord::Migration
  def self.up
    create_table :issue_status_logs do |t|
      t.integer :issue_id
      t.integer :status_log_id

      t.timestamps
    end
  end

  def self.down
    drop_table :issue_status_logs
  end
end
