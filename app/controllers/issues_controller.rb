class IssuesController < ApplicationController
  before_filter :must_login_first
  before_filter :find_issue, :only => [:show, :edit, :update, :destroy, :change_state, :assign_to]
  before_filter :only => [:edit, :update, :destroy] do |c|
    redirect_to_root_when_no_permission unless current_user.can_manage_issue? @issue
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
      Activity.create!(:user_id => current_user.id,
                       :event_name => 'create_issue',
                       :target_type => 'Issue',
                       :target_id => @issue.id,
                       :related_id => @project.id,
                       :related_type => 'Project',
                       :data => {:title => @issue.title, :related_name => @project.name}
                      )
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
          Activity.create!(:user_id => current_user.id,
                           :event_name => 'change_issue_state',
                           :target_id => @issue.id,
                           :target_type => 'Issue',
                           :data => {:current_state => @issue.current_state.name, :issue_title => @issue.title}
                          )
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
    Activity.create!(:user_id => current_user.id,
                     :event_name => 'assign_issue',
                     :target_id => @issue.id,
                     :target_type => 'Issue',
                     :related_id => params[:user_id],
                     :related_type => 'User', 
                     :data => {:issue_title => @issue.title, :related_name => user.name}
                    )

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

  def rebuild_index
    respond_to do |format|
      format.html {
        redirect_to root_path and return unless current_user.root?

        Issue.rebuild_index!
        redirect_to root_path
      }

      format.js {
        render :text => "ERROR", :status => 403 and return unless current_user.root?

        Issue.rebuild_index!
        head :ok
      }

    end

  end

  def autocomplete
    respond_to do |format|
      format.js { 
        result = []
        term = params[:term].strip
        render :json => result and return if term.index('#')

        Issue.search_with_ferret(%(title:'#{term}')) do |index, id, score|
          issue = Issue.find(index[id][:id])
          result << {:label => issue.title, :value => "issue-#{issue.id}"}
        end
        render :json => result
      }
    end
  end

  private
    def find_issue
      @issue = Issue.find(params[:id])
    end

end

