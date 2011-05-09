class Sudo::UsersController < ApplicationController
  layout 'sudo'

  before_filter :must_login_first
  before_filter do |c|
    redirect_to root_path, :notice => t('permission.no_permission') unless current_user.root?
  end


  def index
    @users = User.all
  end
end
