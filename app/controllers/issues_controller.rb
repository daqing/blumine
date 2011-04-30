class IssuesController < ApplicationController
  before_filter :must_login_first
  before_filter :find_issue, :only => [:show, :edit, :update, :destroy, :change_state, :assign_to]
  before_filter :only => [:edit, :update, :destroy] do |c|
    c.creator_required(@issue)
  end

  def show
    breadcrumbs.add t(:all_projects), projects_path
    breadcrumbs.add @issue.project.name, project_path(@issue.project)
    breadcrumbs.add @issue.title, issue_path(@issue)

    @comment = @issue.comments.new
    @todo_item = @issue.todo_items.new
    @title = @issue.title
  end

  def new
    @project = Project.find(params[:project_id])
    @issue = @project.issues.new
    @title = t('issue.create')
  end

  def create
    @project = Project.find(params[:project_id])
    @issue = @project.issues.new(params[:issue])
    @issue.user = current_user 
    if @issue.save
      redirect_to @issue
    else
      render :new
    end
  end

  def edit
    @project = @issue.project
    @title = t('issue.edit')
  end

  def update
    respond_to do |format|
      if @issue.update_attributes(params[:issue])
        format.html { redirect_to @issue }
        format.js { render :nothing => true }
      else
        format.html { redirect_to root_path }
        format.js { render :text => "SAVE_FAILED", :status => 500 }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @issue.destroy
        format.html { redirect_to @issue.project }
        format.js { render :nothing => true }
      else
        format.html { redirect_to root_path }
        format.js { render :text => "DESTROY_FAILED", :status => 500 }
      end
    end
  end

  def change_state
    event_action = "#{params[:event]}!"
    respond_to do |format|
      if @issue.respond_to? event_action
        begin
          @issue.send(event_action)
          format.html { redirect_to [@issue.project, @issue] }
          format.js { render :layout => false }
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

  def assign_to
    user = User.find(params[:user_id])
    @issue.assigned_user = user

    respond_to do |format|
      format.html { redirect_to @issue }
      format.js
    end
  end

  def search
    @result = []
    Issue.search_with_ferret(%(title|content:'#{params[:keyword]}')) do |index, id, score|
      @result << Issue.find(index[id][:id])
    end
  end

  private
    def find_issue
      @issue = Issue.find(params[:id])
    end

end

