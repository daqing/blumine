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

require 'rmmseg'
require 'rmmseg/ferret'

class Issue < ActiveRecord::Base
  include Workflow

  workflow do
    state :open do
      event :work_on, :transitions_to => :working_on
      event :mark_invalid, :transitions_to => :invalid
      event :ignore, :transitions_to => :ignored
      event :close, :transitions_to => :closed
    end

    state :working_on do
      event :mark_finished, :transitions_to => :finished
    end

    state :finished do
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
    I18n.t("issue.state.#{state_sym.to_s}")
  end

  def self.event_name(event_sym)
    I18n.t("issue.event.#{event_sym.to_s}")
  end

  def self.valid_state?(state_sym)
    self.workflow_spec.states.keys.member? state_sym
  end

  def self.get_index_dir
    File.join(Rails.root, 'index', Rails.env, self.to_s.downcase)
  end

  def self.search_with_ferret(query, &block)
    index = get_index
    index.search_each(query) { |id, score| block.call(index, id, score) if block_given? }
  end

  def self.rm_index_dir
    index_dir = get_index_dir
    FileUtils.rm_r index_dir if File.exists? index_dir
  end

  def self.rebuild_index!
    rm_index_dir
    index = get_index
    all.each do |issue|
      index << issue.to_index_hash
    end
    index.commit
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
