# == Schema Information
# Schema version: 20110516042343
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

  validates :project_id, :title, :content, :presence => true
end
