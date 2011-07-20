# == Schema Information
# Schema version: 20110719035845
#
# Table name: conversations
#
#  id         :integer         not null, primary key
#  project_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)
#

class Conversation < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  has_many :replies
  accepts_nested_attributes_for :replies
end
