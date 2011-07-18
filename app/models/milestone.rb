# == Schema Information
# Schema version: 20110717130007
#
# Table name: milestones
#
#  id         :integer         not null, primary key
#  project_id :integer
#  name       :string(255)
#  due_date   :date
#  created_at :datetime
#  updated_at :datetime
#  start_date :date
#

class Milestone < ActiveRecord::Base
  belongs_to :project

  has_many :issues

  validates :project_id, :name, :presence => true
end
