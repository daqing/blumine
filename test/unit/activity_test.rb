require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  test "should create activity" do
    activity = Activity.new
    assert !activity.save

    activity.user = users(:daqing)
    assert !activity.save

    activity.event_name = 'created_project'
    assert activity.save
  end

  test "should automatically serilize data as JSON" do
    one = activities(:one)
    data = {'foo' => 'bar', 'time' => Time.now}
    one.data = data
    one.save

    assert_equal one.origin_data, ActiveSupport::JSON.encode(data)
  end
end
