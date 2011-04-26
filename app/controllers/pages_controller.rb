class PagesController < ApplicationController
  def index
    @projects = Project.all if current_user
    @title = t(:home)
  end
end
