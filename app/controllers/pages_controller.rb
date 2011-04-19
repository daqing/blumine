class PagesController < ApplicationController
  def index
    @projects = Project.all if current_user
  end
end
