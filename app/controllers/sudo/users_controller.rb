class Sudo::UsersController < ApplicationController
  layout 'sudo'

  before_filter :must_login_first
  before_filter do |c|
    redirect_to root_path, :notice => t('permission.no_permission') unless current_user.root?
  end


  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to sudo_path, :success => success_do(:delete_user)
    else
      redirect_to sudo_path, :notice => failed(:delete_user)
    end
  end

end
