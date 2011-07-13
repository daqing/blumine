# == Schema Information
# Schema version: 20110713034854
#
# Table name: projects
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  logo       :string(255)
#

class Project < ActiveRecord::Base
  belongs_to :user

  has_many :issues, :dependent => :destroy
  has_many :milestones, :dependent => :destroy
  has_many :activities, :dependent => :destroy
  has_many :documents, :dependent => :destroy
  has_many :conversations, :dependent => :destroy

  validates :name, :user_id, :presence => true

  attr_accessible :logo
  mount_uploader :logo, ImageUploader
end

