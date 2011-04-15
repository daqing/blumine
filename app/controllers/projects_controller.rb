class ProjectsController < ApplicationController
  def new
    @project = current_user.projects.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
