class ProjectsController < ApplicationController
  def index
    @projects = Project.all
    breadcrumbs.add 'Projects'
  end

  def show
    @project = Project.find(params[:id])
    breadcrumbs.add 'Projects', projects_path
    breadcrumbs.add @project.name
  end

  def new
    @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.new(params[:project])
    if @project.save
      redirect_to @project
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
