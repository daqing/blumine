require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "should create comment" do
    c = Comment.new
    assert ! c.save

    c.content = "need fix"
    c.issue = issues(:bug_report)
    c.user = users(:daqing)
    assert c.save
  end
end
