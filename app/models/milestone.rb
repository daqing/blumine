# == Schema Information
# Schema version: 20110520082002
#
# Table name: milestones
#
#  id         :integer         not null, primary key
#  project_id :integer
#  name       :string(255)
#  due_date   :date
#  created_at :datetime
#  updated_at :datetime
#

class Milestone < ActiveRecord::Base
  belongs_to :project

  has_many :issues

  validates :project_id, :name, :due_date, :presence => true
end
