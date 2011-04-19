require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @issue = issues(:bug_report)
    ensure_logged_in
  end

  test "should create comment" do
    assert_difference("Comment.count") do
      create_comment
    end

    assert assigns(:issue)
    assert_redirected_to project_issue_path(assigns(:issue).project, assigns(:issue))
  end

  test "should not create comment if not logged in" do
    logout
    create_comment
    assert_redirected_to login_path
  end

  private
    def create_comment
      post :create, :issue_id => @issue.id, :comment => {:content => "foobar"}
    end

end
