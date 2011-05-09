# == Schema Information
# Schema version: 20110509082744
#
# Table name: activities
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  event_name  :string(255)
#  target_type :string(255)
#  target_id   :integer
#  data        :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Activity < ActiveRecord::Base
  belongs_to :user
  
  default_scope :order => 'created_at DESC'

  validates :user_id, :event_name, :target_type, :target_id, :presence => true

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
