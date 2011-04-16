require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @issue = issues(:bug_report)
    ensure_logged_in
  end

  test "should create comment" do
    assert_difference("Comment.count") do
      post :create, :issue_id => @issue.id, :comment => {:content => "foobar"}
    end

    assert assigns(:issue)
    assert_redirected_to issue_path(assigns(:issue))
  end
end
