# == Schema Information
# Schema version: 20110415124331
#
# Table name: projects
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Project < ActiveRecord::Base
  belongs_to :user

  validates :name, :presence => true
end

