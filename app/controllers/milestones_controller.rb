class MilestonesController < ApplicationController
  before_filter :must_login_first
  before_filter :find_project
  before_filter :find_milestone, :only => [:edit, :show, :update, :destroy]
  before_filter :only => [:new, :create, :edit, :update, :destroy] do |c|
    redirect_to_root_when_no_permission unless can? :manage_milestone, @project
  end

  def new
    @milestone = @project.milestones.new
    @heading_name = t(:create_milestone)

    breadcrumbs.add @project.name, project_path(@project)
    breadcrumbs.add t(:create_milestone)

    render 'form'
  end

  def create
    @milestone = @project.milestones.build(params[:milestone])
    if @milestone.save
      # create activity
      begin
        Activity.create!(:user_id => current_user.id,
                         :event_name => 'create_milestone',
                         :target_id => @milestone.id,
                         :data => {:name => @milestone.name, :url => project_milestone_path(@project, @milestone)},
                         :project_id => @project.id
                        )
      rescue
      end
      redirect_to project_issues_path(@project)
    else
      render :new
    end
  end

  def show
  end

  def edit
    @heading_name = t(:edit_milestone)
    render 'form'
  end

  def update
    if @milestone.update_attributes(params[:milestone])
      redirect_to project_issues_path(@project)
    else
      render :text => 'ERROR', :status => 500
    end
  end

  def destroy
    if @milestone.destroy
      redirect_to project_issues_path(@project)
    else
      render :text => 'ERROR', :status => 500
    end
  end

  private
    def find_milestone
      @milestone = @project.milestones.find(params[:id])
    end
end
