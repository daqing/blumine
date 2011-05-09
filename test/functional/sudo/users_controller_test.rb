require 'test_helper'

class Sudo::UsersControllerTest < ActionController::TestCase
  test "other users will be redirected to root path" do
    log_in(:two)
    get :index
    assert_redirected_to root_path
  end
end
