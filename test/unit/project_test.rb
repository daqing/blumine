require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "should provide name" do
    p = Project.new
    assert ! p.save
  end
end
