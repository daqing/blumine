require 'test_helper'

class VersionTest < ActiveSupport::TestCase
  test "all fields are required" do
    version = Version.new
    assert !version.save
  end
end
