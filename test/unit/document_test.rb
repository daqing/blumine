require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  test "all fields are required" do
    doc = Document.new
    assert ! doc.save
  end
end
