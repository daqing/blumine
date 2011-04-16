class IssuesController < ApplicationController
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
  end

  def destroy
  end

end
