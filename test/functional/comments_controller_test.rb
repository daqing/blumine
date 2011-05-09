require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @issue = issues(:bug_report)
    log_in(:daqing)
  end

  test "should create comment" do
    assert_difference("Comment.count") do
      create_comment
    end

    assert assigns(:issue)
    assert_redirected_to assigns(:issue)
  end

  test "should not create comment if not logged in" do
    log_out
    create_comment
    assert_redirected_to login_path
  end

  test "should edit comment" do
    get :edit, :id => comments(:need_fix).id

    assert_response :success
  end

  test "should edit comment via ajax call" do
    xhr :get, :edit, :id => comments(:need_fix).id

    assert_response :success
  end

  test "should update comment" do
    post :update, :id => comments(:need_fix).id, :comment => {:content => comments(:two).content}

    assert assigns(:comment)
    assert_redirected_to assigns(:comment).issue
    assert_equal comments(:two).content, assigns(:comment).content
  end

  test "should update comment via ajax call" do
    xhr :post, :update, :id => comments(:need_fix).id, :comment => {:content => comments(:two).content}

    assert_response :success
  end

  test "should destroy comment" do
    delete :destroy, :id => comments(:need_fix).id

    assert assigns(:comment)
    assert_redirected_to assigns(:comment).issue
  end

  test "only user who creates it can edit or destroy comment" do
    get :edit, :id => comments(:two).id
    assert_no_priviledge

    post :update, :id => comments(:two).id, :comment => {:content => comments(:need_fix).content}
    assert_no_priviledge

    delete :destroy, :id => comments(:two).id
    assert_no_priviledge
  end

  private
    def create_comment
      post :create, :issue_id => @issue.id, :comment => {:content => "foobar"}
    end

    def assert_no_priviledge
      assert flash[:notice]
      assert_redirected_to root_path
    end

end
