class MilestonesController < ApplicationController
  before_filter :must_login_first
  before_filter :find_project
  before_filter :find_milestone, :only => [:edit, :update, :destroy]
  before_filter :root_required, :only => [:edit, :update, :destroy]

  def new
    @milestone = @project.milestones.new
    @action_name = :create_milestone
    render 'form'
  end

  def create
    @milestone = @project.milestones.build(params[:milestone])
    if @milestone.save
      redirect_to @project
    else
      render :new
    end
  end

  def edit
    @action_name = :edit_milestone
    render 'form'
  end

  def update
    if @milestone.update_attributes(params[:milestone])
      redirect_to @project
    else
      render :text => 'ERROR', :status => 500
    end
  end

  def destroy
    if @milestone.destroy
      redirect_to @project
    else
      render :text => 'ERROR', :status => 500
    end
  end

  private
    def find_project
      @project = Project.find(params[:project_id])
    end

    def find_milestone
      @milestone = @project.milestones.find(params[:id])
    end
end
