# == Schema Information
# Schema version: 20110703034007
#
# Table name: replies
#
#  id              :integer         not null, primary key
#  conversation_id :integer
#  user_id         :integer
#  content         :text
#  created_at      :datetime
#  updated_at      :datetime
#

class Reply < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user

  has_many :uploads
  accepts_nested_attributes_for :uploads
end
