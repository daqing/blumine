class IssuesController < ApplicationController
  before_filter :must_login_first
  before_filter :find_issue, :only => [:show, :edit, :update, :destroy, :change_state, :assign_to]
  before_filter :only => [:edit, :update, :destroy] do |c|
    authorize! :manage, @issue
  end

  def index
    @project = Project.find(params[:project_id])
    if params[:state]
      @issue_state = Issue.valid_state?(params[:state].to_sym) ? params[:state] : :all
    else
      @issue_state = :all
    end

    @title = @project.name
    breadcrumbs.add @project.name, project_path(@project)
    breadcrumbs.add 'Issues', project_issues_path(@project)

    if @issue_state == :all
      @issues = @project.issues.except_closed
    else
      @issues = @project.issues.send("only_#{@issue_state}")
    end
  end

  def show
    breadcrumbs.add @issue.project.name, project_path(@issue.project)
    breadcrumbs.add '#' + "#{@issue.label}-#{@issue.id}", issue_path(@issue)

    @comment = @issue.comments.new
    @todo_item = @issue.todo_items.new
    @title = @issue.title
  end

  def view_by_label
    @label = params[:label]
    @project = Project.find(params[:project_id])
    @issues = @project.issues.where(['label = ?', @label])
    @title = @project.name
    breadcrumbs.add t(:all_projects), projects_path
    breadcrumbs.add @project.name, project_path(@project)
    
    render :index
  end

  def new
    @project = Project.find(params[:project_id])
    @issue = @project.issues.new
    @title = t('issue.create')
    @label = params[:label]
    
    breadcrumbs.add @issue.project.name, project_path(@issue.project)
    breadcrumbs.add t("new_#{@label}")
  end

  def create
    @project = Project.find(params[:project_id])
    @issue = @project.issues.new(params[:issue])
    @issue.label = params[:issue][:label]
    @issue.user = current_user 
    if @issue.save
      Activity.create!(
        :user_id => current_user.id,
        :project_id => params[:project_id],
        :event_name => 'create_issue',
        :target_id => @issue.id,
        :data => { :title => @issue.title, :project_name => @project.name, :label => @issue.label }
      )
      redirect_to @issue
    else
      render :new
    end
  end

  def edit
    @project = @issue.project
    @title = t('issue.edit')
    
    breadcrumbs.add @issue.project.name, project_path(@issue.project)
    breadcrumbs.add '#' + "#{@issue.label}-#{@issue.id}", issue_path(@issue)
    breadcrumbs.add t(:edit)
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
    authorize! :change_state, @issue
    respond_to do |format|
      if @issue.current_state.events.keys.member? params[:event].to_sym
        begin
          event_action = "#{params[:event]}!"
          @issue.send(event_action)
          Activity.create!(
            :user_id => current_user.id,
            :project_id => @issue.project.id,
            :event_name => 'change_issue_state',
            :target_id => @issue.id,
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
    authorize! :assign, @issue
    user = User.find(params[:user_id])
    @issue.assigned_user = user
    Activity.create!(
      :user_id => current_user.id,
      :project_id => @issue.project.id,
      :event_name => 'assign_issue',
      :target_id => @issue.id,
      :data => {
        :issue_title => @issue.title,
        :assigned_id => params[:user_id],
        :assigned_name => user.name
      }
    )

    respond_to do |format|
        format.html { redirect_to @issue }
        format.js
    end
  end
  
  def planning
    @issue = Issue.find(params[:id])
    @new_date = params[:date].blank? ? '' : Date.parse(params[:date])
      
    if @issue.update_attributes(:planned_date => @new_date)
      render :json => {:success => true}
    else
      render :json => {:success => false}
    end
      
  end

  def search
    @result = []
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
        render :json => result and return if params[:term].nil? or params[:term].index('#') or params[:term] =~ /^issue/

        Issue.search_with_ferret(%(title:'#{params[:term]}')) do |index, id, score|
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

