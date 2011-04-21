# == Schema Information
# Schema version: 20110421080032
#
# Table name: issue_assignments
#
#  id         :integer         not null, primary key
#  issue_id   :integer
#  user_id    :integer
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

class IssueAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :issue

  acts_as_list

  validates :issue_id, :user_id, :presence => true
end
