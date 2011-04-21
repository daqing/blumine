# == Schema Information
# Schema version: 20110420150709
#
# Table name: todo_items
#
#  id             :integer         not null, primary key
#  issue_id       :integer
#  content        :text
#  created_at     :datetime
#  updated_at     :datetime
#  workflow_state :string(255)
#  position       :integer
#

class TodoItem < ActiveRecord::Base
  include Workflow

  workflow do
    state :open do
      event :finish, :transitions_to => :done
    end

    state :done do
      event :undo, :transitions_to => :open
    end
  end

  acts_as_list

  default_scope :order => 'position ASC'

  belongs_to :issue

  validates :issue_id, :content, :presence => true
end
