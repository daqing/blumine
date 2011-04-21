require 'test_helper'

class IssueAssignmentTest < ActiveSupport::TestCase
  setup do
    @issue = issues(:bug_report)
    @user = users(:daqing)
  end

  test "should not assign nil user" do
    ia = IssueAssignment.new
    assert ! ia.save

    ia.user_id = @user.id
    assert ! ia.save
  end

  test "should assign issue to daqing" do
    ia = IssueAssignment.new(:issue_id => @issue.id, :user_id => @user.id)
    assert ia.save


    assert_equal @issue.assigned_user, @user
  end
end
