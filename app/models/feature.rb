# == Schema Information
# Schema version: 20110516041751
#
# Table name: features
#
#  id         :integer         not null, primary key
#  version_id :integer
#  user_id    :integer
#  title      :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Feature < ActiveRecord::Base
  belongs_to :version

  validates :version_id, :user_id, :title, :content, :presence => true
end
