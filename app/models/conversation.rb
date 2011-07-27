# == Schema Information
# Schema version: 20110727043210
#
# Table name: conversations
#
#  id         :integer         not null, primary key
#  project_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)
#  issue_id   :integer
#

class Conversation < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :issue

  has_many :replies
  accepts_nested_attributes_for :replies
end
