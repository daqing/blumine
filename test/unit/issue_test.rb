require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  setup do
    @issue = Issue.new
  end

  test "title and content are required" do
    assert ! @issue.save

    @issue.title = "foobar"
    assert ! @issue.save

    @issue.content = "Just a test"
    assert @issue.save
  end

  test "initial state of issue" do
    assert @issue.new?
  end
end
