require 'test_helper'

class StatusLogTest < ActiveSupport::TestCase
  test "content and user_id is required" do
    log = StatusLog.new
    assert ! log.save

    log.user = users(:daqing)
    assert ! log.save

    log.content = "hello!"
    assert log.save
  end
end
