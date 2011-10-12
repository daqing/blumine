class UserSessionsController < ApplicationController
  before_filter :must_not_logged_in, :only => :create
  before_filter :must_be_logged_in, :only => :destroy

  def create
    @user_session = UserSession.new(params[:user_session])

    respond_to do |format|
      if @user_session.save
        target_url = target_url_after_login
        format.html { redirect_back_or target_url}
        format.xml  { render :xml => @user_session, :status => :created, :location => target_url}
      else
        format.html { render :new, :layout => 'focus' }
        format.xml  { render :xml => @user_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy

    respond_to do |format|
      format.html { redirect_to root_path, :notice => success_do(:logout) }
      format.xml  { head :ok }
    end
  end
end
