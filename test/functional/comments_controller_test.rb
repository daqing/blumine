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
    assert_redirected_to assigns(:issue)
  end

  test "should not create comment if not logged in" do
    logout
    create_comment
    assert_redirected_to login_path
  end

  test "should edit comment" do
    get :edit, :id => comments(:need_fix).id

    assert_response :success
  end

  test "should update comment" do
    post :update, :id => comments(:need_fix).id, :comment => {:content => comments(:two).content}

    assert assigns(:comment)
    assert_redirected_to assigns(:comment).issue
    assert_equal comments(:two).content, assigns(:comment).content
  end

  test "should destroy comment" do
    delete :destroy, :id => comments(:need_fix).id

    assert assigns(:comment)
    assert_redirected_to assigns(:comment).issue
  end

  private
    def create_comment
      post :create, :issue_id => @issue.id, :comment => {:content => "foobar"}
    end

end
