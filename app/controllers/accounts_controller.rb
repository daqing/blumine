class AccountsController < ApplicationController
  before_filter :must_login_first

  def show
    breadcrumbs.add t(:account_settings)
    render :layout => 'single_column'
  end

  def update
    if current_user.update_attributes(params[:user])
      flash[:success] = success_do(:updated)
    else
      flash[:error] = failed_do(:update)
    end
    redirect_to account_path
  end

end
