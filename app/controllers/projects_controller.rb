class ProjectsController < ApplicationController
  before_filter :must_login_first

  def index
    @projects = Project.all
    @title = t(:all_projects)

    breadcrumbs.add t(:all_projects), projects_path
  end

  def show
    @project = Project.find(params[:id])
    if params[:state]
      @issue_state = Issue.valid_state?(params[:state].to_sym) ? params[:state] : :all
    else
      @issue_state = :all
    end

    @title = @project.name
    breadcrumbs.add t(:all_projects), projects_path
    breadcrumbs.add @project.name, project_path(@project)

    if @issue_state == :all
      @issues = @project.issues.except_closed.except_ignored
    else
      @issues = @project.issues.send("only_#{@issue_state}")
    end
  end

  def view_by_label
    @label = params[:label]
    @issues = Issue.where(['label = ?', @label])
    @project = Project.find(params[:id])
    @title = @project.name
    breadcrumbs.add t(:all_projects), projects_path
    breadcrumbs.add @project.name, project_path(@project)
    
    render :show
  end

  def new
    @project = current_user.projects.new
    @title = t(:new_project)
  end

  def create
    @project = current_user.projects.new(params[:project])
    if @project.save
      Activity.create!(:user_id => current_user.id,
                     :event_name => 'create_project',
                     :target_type => 'Project',
                     :target_id => @project.id,
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
  end

end
