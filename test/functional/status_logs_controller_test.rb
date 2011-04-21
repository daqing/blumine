require 'test_helper'

class StatusLogsControllerTest < ActionController::TestCase
  setup do
    ensure_logged_in
  end

  test "only logged-in users can create or destroy status log" do
    logout

    create_status_log
    assert_redirected_to root_path

    destroy_status_log
    assert_redirected_to root_path
  end

  test "should create status log" do
    assert_difference('StatusLog.count') do
      create_status_log
    end 

    assert_response :success
    assert assigns(:status_log)
  end

  test "should destroy status log" do
    assert_difference('StatusLog.count', -1) do
      destroy_status_log
    end

    assert_response :success
    assert assigns(:status_log)
  end

  test "only creator can destroy status log" do
    xhr :delete, :destroy, :id => status_logs(:two).id

    assert_redirected_to root_path
  end

  private
    def create_status_log
      xhr :post, :create, :status_log => {:content => "hello"}
    end

    def destroy_status_log
      xhr :delete, :destroy, :id => status_logs(:one).id
    end
end
