require 'test_helper'

class Sudo::UsersControllerTest < ActionController::TestCase
  test "other users will be redirected to root path" do
    log_in(:two)
    get :index
    assert_redirected_to root_path
  end

  test "only root can destroy user" do
    log_in(:daqing)
    delete :destroy, :id => users(:daqing).id
    assert_response :redirect
  end

end
