require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  setup do
    log_in(:daqing)
  end

  test "must login first to view account" do
    log_out

    get :show
    assert_redirected_to root_path

    post :update
    assert_redirected_to root_path 
  end

  test "should get show" do
    get :show
    assert_response :success
    assert_select 'form.edit_user'
  end

  test "should update account settings" do
    new_locale = 'en'
    post :update, :user => {:locale => new_locale}
    assert_redirected_to account_path

    assert_equal new_locale, current_user.locale
  end

  test "role can not be updated via form" do
    relog_in(:two)
    assert current_user.role == 'Developer'
    post :update, :user => {:role => 'Developer'}
    assert current_user.role == 'Developer'
  end
end
