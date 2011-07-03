# == Schema Information
# Schema version: 20110703080201
#
# Table name: document_sections
#
#  id          :integer         not null, primary key
#  document_id :integer
#  title       :string(255)
#  content     :text
#  created_at  :datetime
#  updated_at  :datetime
#

class DocumentSection < ActiveRecord::Base
end
