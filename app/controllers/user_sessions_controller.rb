class UserSessionsController < ApplicationController
  before_filter :must_not_logged_in, :only => [:new, :create]
  before_filter :must_be_logged_in, :only => :destroy

  def new
    @user_session = UserSession.new
    breadcrumbs.add t(:log_in)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_session }
    end
  end

  def create
    @user_session = UserSession.new(params[:user_session])

    respond_to do |format|
      if @user_session.save
        format.html { redirect_back_or root_path }
        format.xml  { render :xml => @user_session, :status => :created, :location => root_path }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy

    respond_to do |format|
      format.html { redirect_to root_path, :notice => "您已经成功退出。" }

      format.xml  { head :ok }
    end
  end
end
