# == Schema Information
# Schema version: 20110516042343
#
# Table name: versions
#
#  id           :integer         not null, primary key
#  project_id   :integer
#  user_id      :integer
#  name         :string(255)
#  release_date :date
#  created_at   :datetime
#  updated_at   :datetime
#

class Version < ActiveRecord::Base
  belongs_to :project
  has_many :features, :dependent => :destroy

  validates :project_id, :name, :release_date, :presence => true
end
