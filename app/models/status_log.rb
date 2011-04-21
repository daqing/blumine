# == Schema Information
# Schema version: 20110421135437
#
# Table name: status_logs
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class StatusLog < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :content, :presence => true
end
