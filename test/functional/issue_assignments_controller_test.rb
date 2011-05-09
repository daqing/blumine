require 'test_helper'

class IssueAssignmentsControllerTest < ActionController::TestCase
  setup do
    log_in(:daqing)
    issues(:bug_report).assigned_user = current_user
  end

  test "only logged-in users can sort" do
    log_out
    post :sort, :issue => [issues(:bug_report).id, issues(:two).id]
    assert_redirected_to root_path
  end

  test "should sort assigned issues" do
    ia = IssueAssignment.where(:issue_id => issues(:bug_report).id, :user_id => current_user.id).first
    ia.position = 10
    xhr :post, :sort, :issue => [issues(:bug_report).id, issues(:two).id]

    assert_response :success
    assert_equal 1, IssueAssignment.where(:issue_id => issues(:bug_report).id, :user_id => current_user.id).first.position
  end
end
