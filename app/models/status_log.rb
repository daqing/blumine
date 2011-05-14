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

  has_many :issue_status_logs, :dependent => :destroy
  has_many :related_issues, :through => :issue_status_logs, :source => :issue

  default_scope :order => 'created_at DESC'

  validates :user_id, :content, :presence => true

  after_create :parse_related_issues

  private
    def parse_related_issues
        self.content.scan(/#issue-(\d+)/) {|id| self.related_issues << Issue.find(id) }
    end
end
