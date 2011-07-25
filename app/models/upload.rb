# == Schema Information
# Schema version: 20110717082415
#
# Table name: uploads
#
#  id           :integer         not null, primary key
#  project_id   :integer
#  reply_id     :integer
#  asset        :string(255)
#  file_size    :integer
#  content_type :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  user_id      :integer
#

class Upload < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :reply

  attr_accessible :asset
  validates :project_id, :user_id, :asset, :presence => true

  mount_uploader :asset, AssetUploader
  before_save :set_asset_info

  def image?
    self.content_type && self.content_type.include?('image')
  end

  private
    def set_asset_info
      self.content_type = asset.file.content_type
      self.file_size = asset.file.size
    end
end
