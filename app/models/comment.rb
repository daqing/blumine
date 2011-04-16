# == Schema Information
# Schema version: 20110416123631
#
# Table name: comments
#
#  id         :integer         not null, primary key
#  issue_id   :integer
#  user_id    :integer
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user

  validates :issue_id, :user_id, :content, :presence => true
end
