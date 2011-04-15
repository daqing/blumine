require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    # create an user first
    activate_authlogic
    UserSession.create(users(:daqing))
  end
  
  test "should get new" do
    get :new, :user_id => current_user.id
    assert_response :success

    assert assigns(:project)
  end
end
