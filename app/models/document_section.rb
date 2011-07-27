# == Schema Information
# Schema version: 20110726032013
#
# Table name: document_sections
#
#  id          :integer         not null, primary key
#  document_id :integer
#  title       :string(255)
#  content     :text
#  created_at  :datetime
#  updated_at  :datetime
#  position    :integer
#

class DocumentSection < ActiveRecord::Base
  acts_as_list
  belongs_to :document

  default_scope :order => 'position ASC, id DESC'

  validates :document_id, :title, :content, :presence => true
end
