# == Schema Information
# Schema version: 20110717130007
#
# Table name: project_members
#
#  id         :integer         not null, primary key
#  project_id :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class ProjectMember < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
end
