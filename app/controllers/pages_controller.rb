class PagesController < ApplicationController
  def index
    if current_user 
      @title = t(:dashboard)
      @users_working_on = {}
      Issue.only_working_on.each do |issue|
        user = issue.assigned_user
        if @users_working_on[user]
          @users_working_on[user] << issue
        else
          @users_working_on[user] = [issue]
        end
      end
      render 'dashboard'
    else
      @title = t(:home)
      render 'index'
    end
  end
end
