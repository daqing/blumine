require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  setup do
    @issue = Issue.new
  end

  test "required fields" do
    assert ! @issue.save

    @issue.title = "foobar"
    assert ! @issue.save

    @issue.content = "Just a test"
    assert ! @issue.save # user_id and project_id is required

    @issue.project_id = 1
    @issue.user_id = 1

    assert ! @issue.save

    @issue.label = 'idea'
    assert @issue.save
  end
end
