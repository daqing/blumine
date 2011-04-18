# == Schema Information
# Schema version: 20110418064528
#
# Table name: todo_items
#
#  id         :integer         not null, primary key
#  issue_id   :integer
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class TodoItem < ActiveRecord::Base
  belongs_to :issue

  validates :issue_id, :content, :presence => true
end
