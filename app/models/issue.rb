# == Schema Information
# Schema version: 20110605071315
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
#  label          :string(255)
#  milestone_id   :integer
#  planned_date   :date
#

class Issue < ActiveRecord::Base
  include Workflow

  workflow do
    state :open do
      event :work_on, :transitions_to => :working_on
      event :close, :transitions_to => :closed
    end

    state :working_on do
      event :pause, :transitions_to => :paused
      event :mark_finished, :transitions_to => :finished
    end

    state :paused do
      event :continue, :transitions_to => :working_on
      event :close, :transitions_to => :closed
    end

    state :finished do
      event :continue, :transitions_to => :working_on
      event :close, :transitions_to => :closed
    end

    state :closed do
      event :reopen, :transitions_to => :reopened
    end

    state :reopened do
      event :work_on, :transitions_to => :working_on
    end
  end

  belongs_to :project
  belongs_to :user
  belongs_to :milestone

  has_many :comments, :dependent => :destroy
  has_many :todo_items, :dependent => :destroy

  has_one :issue_assignment, :dependent => :destroy
  has_one :assigned_user, :through => :issue_assignment, :source => :user

  before_validation :set_default_content

  attr_protected :label

  validates :title, :content, :presence => true
  validates :user_id, :project_id, :presence => true
  validates :label, :presence => true, :on => :create

  def self.all_states
    [:open, :working_on, :paused, :finished, :closed, :reopened]
  end

  def self.state_name(state_sym)
    I18n.t("issue.state.#{state_sym.to_s}")
  end

  def self.event_name(event_sym)
    I18n.t("issue.event.#{event_sym.to_s}")
  end

  def self.valid_state?(state_sym)
    self.workflow_spec.states.keys.member? state_sym
  end

  def current_state_name
    Issue.state_name(self.current_state.name)
  end

  def default_content
    I18n.t('issue.default_content')
  end

  class << self
    Issue.workflow_spec.states.keys.each do |state_sym|
      define_method("only_#{state_sym.to_s}") do
        where(:workflow_state => state_sym)
      end

      define_method("except_#{state_sym.to_s}") do
        where(["workflow_state != ?", state_sym.to_s])
      end
    end
  end

  def to_index_hash
    {:id => self.id, :title => self.title, :content => self.content}
  end

  private
    def set_default_content
      self.content = default_content if self.content.blank?
    end

    def self.get_index
      index_dir = Issue.get_index_dir
      FileUtils.mkdir_p(index_dir) unless File.exists?(index_dir)

      analyzer = RMMSeg::Ferret::Analyzer.new { |tok| Ferret::Analysis::LowerCaseFilter.new(tok) }
      Ferret::Index::Index.new(:path => index_dir, :analyzer => analyzer, :key => :id)
    end
end
