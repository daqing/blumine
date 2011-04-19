class UsersController < ApplicationController
  def new
    @user = User.new
    breadcrumbs.add '注册'
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    breadcrumbs.add @user.name
  end

end
