class PagesController < ApplicationController
  def index
    if current_user 
      @title = t(:dashboard)
      render 'dashboard'
    else
      @title = t(:home)
      render 'index'
    end
  end
end
