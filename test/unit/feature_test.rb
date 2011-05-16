require 'test_helper'

class FeatureTest < ActiveSupport::TestCase
  test "all fields are required" do
    feature = Feature.new
    assert !feature.save
  end
end
