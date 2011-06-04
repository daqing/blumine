# == Schema Information
# Schema version: 20110604071850
#
# Table name: documents
#
#  id         :integer         not null, primary key
#  project_id :integer
#  user_id    :integer
#  title      :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Document < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  validates :title, :content, :project_id, :user_id, :presence => true
end
