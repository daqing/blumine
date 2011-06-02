# == Schema Information
# Schema version: 20110602082645
#
# Table name: activities
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  event_name :string(255)
#  target_id  :integer
#  data       :text
#  created_at :datetime
#  updated_at :datetime
#  project_id :integer
#

class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  
  default_scope :order => 'created_at DESC'

  validates :user_id, :event_name, :presence => true

  def data=(data)
    write_attribute(:data, ActiveSupport::JSON.encode(data))
  end

  def data
    val = read_attribute(:data)
    ActiveSupport::JSON.decode(val) if val or nil
  end

  def origin_data
    read_attribute(:data)
  end
end
