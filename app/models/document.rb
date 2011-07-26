# == Schema Information
# Schema version: 20110720022526
#
# Table name: documents
#
#  id          :integer         not null, primary key
#  project_id  :integer
#  user_id     :integer
#  title       :string(255)
#  content     :text
#  created_at  :datetime
#  updated_at  :datetime
#  description :string(255)
#

class Document < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  has_many :document_sections, :dependent => :destroy
  accepts_nested_attributes_for :document_sections

  validates :title, :project_id, :user_id, :presence => true
end
