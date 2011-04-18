# == Schema Information
# Schema version: 20110418131302
#
# Table name: todo_items
#
#  id             :integer         not null, primary key
#  issue_id       :integer
#  content        :text
#  created_at     :datetime
#  updated_at     :datetime
#  workflow_state :string(255)
#

class TodoItem < ActiveRecord::Base
  include Workflow

  workflow do
    state :new do
      event :do_it, :transitions_to => :done
    end

    state :done do
      event :undo, :transitions_to => :new
    end
  end

  belongs_to :issue

  validates :issue_id, :content, :presence => true
end
