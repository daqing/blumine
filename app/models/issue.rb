# == Schema Information
# Schema version: 20110416033800
#
# Table name: issues
#
#  id             :integer         not null, primary key
#  project_id     :integer
#  title          :string(255)
#  content        :text
#  workflow_state :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  user_id        :integer
#

class Issue < ActiveRecord::Base
  include Workflow

  workflow do
    state :new do
      event :work_on, :transitions_to => :working_on
    end
  end

  belongs_to :project
  belongs_to :user

  validates :title, :content, :presence => true
  validates :user_id, :project_id, :presence => true
end
