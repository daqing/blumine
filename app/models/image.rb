# == Schema Information
# Schema version: 20110423065001
#
# Table name: images
#
#  id         :integer         not null, primary key
#  file       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Image < ActiveRecord::Base
  mount_uploader :file, ImageUploader

  validates :file, :presence => true
end
