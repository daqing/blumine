require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "should not get new" do
    assert_raise(ActionController::RoutingError) do
      get :new
    end
  end

  test "should define login and log_out path" do
    assert_generates logout_path, :controller => "user_sessions", :action => "destroy"
  end
end
