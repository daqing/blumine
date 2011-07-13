class ProjectsController < ApplicationController
  before_filter :must_login_first
  before_filter :root_required, :only => :destroy

  layout 'single_column'

  def index
    @projects = Project.all
    @title = t(:all_projects)

    breadcrumbs.add t(:all_projects), projects_path
    render :layout => 'single_column'
  end

  def show
    @project = Project.find(params[:id])
    @conversation = @project.conversations.new
    @title = @project.name
    breadcrumbs.add @project.name, project_path(@project)

    render :layout => 'application'
  end

  def new
    @project = current_user.projects.new
    @title = t(:new_project)

    render :layout => 'single_column'
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
      render :new, :layout => 'single_column'
    end
  end

  def edit
    @title = t('projects.edit.edit_project')
    @project = Project.find(params[:id])
    @conversation = @project.conversations.new
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      flash[:success] = success_do(:update)
    else
      flash[:error] = failed_do(:update)
    end

    redirect_to edit_project_path(@project)
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
