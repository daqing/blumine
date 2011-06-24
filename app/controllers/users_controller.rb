class UsersController < ApplicationController
  before_filter :must_login_first, :only => [:show, :index]
  before_filter :must_not_logged_in, :only => [:new, :create]

  def index
    @users = User.page(params[:page])
  end

  def new
    @user = User.new
    @title = t(:register)
    breadcrumbs.add t(:register), register_path
    
    render :layout => 'focus'
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to target_url_after_login
    else
      render :new, :layout => 'focus'
    end
  end

  def show
    @user = User.find(params[:id])
    @my_profile = false
    if @user == current_user
      @title = t(:my_profile)
      @my_profile = true
      breadcrumbs.add t(:my_profile)
    else
      @title = @user.name
      breadcrumbs.add @user.name
    end
    
    assigned_issues = @user.assigned_issues.except_closed
    @planned_issues = {}
    @unplanned_issues = []
    assigned_issues.each do |issue|
      unless issue.planned_date.blank?
        date = issue.planned_date
        if @planned_issues[date]
          @planned_issues[date] << issue
        else
          @planned_issues[date] = [issue]
        end
      else
        @unplanned_issues << issue
      end
    end
  end
end
