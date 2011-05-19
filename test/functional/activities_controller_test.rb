require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase
  setup do
    log_in(:daqing)
  end

  test "should create activity" do
    create_chat
    assert_response :success
  end

  test "user logging in required" do
    log_out
    create_chat
    assert_response :redirect
  end

  private
    def create_chat
      xhr :post, :create, :activity => {:data => 'foobar'}
    end

end
