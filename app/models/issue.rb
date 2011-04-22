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

  @@state_names = {
    :open => "新任务",
    :working_on => "解决中",
    :done => "已解决",
    :closed => "已关闭",
    :invalid => "描述不成立",
    :ignored => "不需解决",
    :reopened => "重新开放"
  }

  @@event_names = {
    :work_on => "开始解决",
    :mark_invalid => "无效描述",
    :ignore => "不需要解决",
    :mark_done => "标记为已解决",
    :reopen => "重新开放",
    :continue => "继续解决",
    :close => "关闭"
  }

  workflow do
    state :open do
      event :work_on, :transitions_to => :working_on
      event :mark_invalid, :transitions_to => :invalid
      event :ignore, :transitions_to => :ignored
    end

    state :working_on do
      event :mark_done, :transitions_to => :done
    end

    state :done do
      event :continue, :transitions_to => :working_on
      event :close, :transitions_to => :closed
    end

    state :invalid do
      event :reopen, :transitions_to => :reopened
    end

    state :closed do
      event :reopen, :transitions_to => :reopened
    end

    state :ignored do
      event :reopen, :transitions_to => :reopened
    end

    state :reopened do
      event :work_on, :transitions_to => :working_on
    end
  end

  belongs_to :project
  belongs_to :user

  has_many :comments
  has_many :todo_items

  has_one :issue_assignment
  has_one :assigned_user, :through => :issue_assignment, :source => :user

  before_validation :set_default_content

  validates :title, :content, :presence => true
  validates :user_id, :project_id, :presence => true

  def self.state_name(state_sym)
    @@state_names[state_sym]
  end

  def self.event_name(event_sym)
    @@event_names[event_sym]
  end

  def self.valid_state?(state_sym)
    self.workflow_spec.states.keys.member? state_sym
  end

  def current_state_name
    Issue.state_name(self.current_state.name)
  end

  def default_content
    "记录在Todo里。"
  end

  class << self
    Issue.workflow_spec.states.keys.each do |state_sym|
      define_method("state_#{state_sym.to_s}") do
        where(:workflow_state => state_sym)
      end

      define_method("except_#{state_sym.to_s}") do
        where(["workflow_state != ?", state_sym.to_s])
      end
    end
  end

  private
    def set_default_content
      self.content = default_content if self.content.blank?
    end
end
