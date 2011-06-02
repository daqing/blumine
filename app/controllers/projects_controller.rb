class ProjectsController < ApplicationController
  before_filter :must_login_first
  before_filter :root_required, :only => :destroy

  def index
    @projects = Project.all
    @title = t(:all_projects)

    breadcrumbs.add t(:all_projects), projects_path
  end

  def show
    @project = Project.find(params[:id])
    @title = @project.name
    breadcrumbs.add @project.name, project_path(@project)
  end

  def new
    @project = current_user.projects.new
    @title = t(:new_project)
  end

  def create
    @project = current_user.projects.new(params[:project])
    if @project.save
      Activity.create!(
        :user_id => current_user.id,
        :event_name => 'create_project',
        :project_id => @project.id,
        :data => {:name => @project.name}
      )
      redirect_to @project
    else
      render :new
    end
  end

  def edit
    @title = t(:edit_project)
  end

  def update
  end

  def destroy
    @project = Project.find(params[:id])
    if @project.destroy
      redirect_to root_path
    else
      render :text => 'ERROR', :status => 500
    end
  end

end
