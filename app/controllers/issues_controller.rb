class IssuesController < ApplicationController
  before_filter :must_login_first

  def new
    @project = Project.find(params[:project_id])
    @issue = @project.issues.new
  end

  def create
    @project = Project.find(params[:project_id])
    @issue = @project.issues.new(params[:issue])
    @issue.user = current_user 
    if @issue.save
      redirect_to [@project, @issue]
    else
      render :new
    end
  end

  def show
    @issue = Issue.find(params[:id])
    breadcrumbs.add 'Projects', projects_path
    breadcrumbs.add @issue.project.name, project_path(@issue.project)
    breadcrumbs.add @issue.title

    @comment = @issue.comments.new
    @todo_item = @issue.todo_items.new
  end

  def destroy
  end

end
