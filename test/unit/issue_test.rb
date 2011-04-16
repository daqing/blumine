require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  test "title and content are required" do
    issue = Issue.new
    assert ! issue.save

    issue.title = "foobar"
    assert ! issue.save

    issue.content = "Just a test"
    assert issue.save
  end
end
