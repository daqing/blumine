require 'test_helper'

class MilestoneTest < ActiveSupport::TestCase
  test "all fields are required" do
    @milestone = Milestone.new
    assert !@milestone.save
  end
end
