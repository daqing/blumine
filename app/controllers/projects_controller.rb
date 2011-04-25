class ProjectsController < ApplicationController
  before_filter :must_login_first

  def index
    @projects = Project.all
    breadcrumbs.add t(:all_projects), projects_path
  end

  def show
    @project = Project.find(params[:id])
    if params[:state]
      @issue_state = Issue.valid_state?(params[:state].to_sym) ? params[:state] : :all
    else
      @issue_state = :all
    end
    breadcrumbs.add t(:all_projects), projects_path
    breadcrumbs.add @project.name, project_path(@project)
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
