# == Schema Information
# Schema version: 20110514032858
#
# Table name: issue_status_logs
#
#  id            :integer         not null, primary key
#  issue_id      :integer
#  status_log_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class IssueStatusLog < ActiveRecord::Base

  belongs_to :issue
  belongs_to :status_log

  validates :issue_id, :status_log_id, :presence => true
end
