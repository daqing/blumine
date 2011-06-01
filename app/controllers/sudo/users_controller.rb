class Sudo::UsersController < ApplicationController
  layout 'sudo'

  before_filter :must_login_first
  before_filter do |c|
    unless current_user.root?
      flash[:error] = t('permission.no_permission')
      redirect_to root_path
    end
  end

  def index
    @users = User.order('created_at DESC').page(params[:page])
  end

  def destroy
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.destroy
        format.html { redirect_to sudo_path, :success => success_do(:delete_user) }
        format.js
      else
        format.html { redirect_to sudo_path, :notice => failed(:delete_user) }
        format.js { render :text => :error, :status => 500 }
      end
    end
  end
end
