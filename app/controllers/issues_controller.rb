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

  def change_state
    @issue = Issue.find(params[:id])
    event_action = "#{params[:event]}!"
    respond_to do |format|
      if @issue.respond_to? event_action
        begin
          @issue.send(event_action)
          format.html { redirect_to [@issue.project, @issue] }
          format.js { render :nothing => true }
        rescue
          format.html { redirect_to root_path }
          format.js { render :text => "ERROR", :status => 500 }
        end
      else
        format.html { redirect_to root_path }
        format.js { render :text => "ERROR", :status => 500 }
      end
    end
  end
end

