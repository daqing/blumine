class MilestonesController < ApplicationController
  before_filter :must_login_first
  before_filter :find_project, :only => [:new, :create]
  before_filter :root_required, :only => :destroy

  def new
    @milestone = @project.milestones.new
  end

  def create
    @milestone = @project.milestones.build(params[:milestone])
    if @milestone.save
      redirect_to @project
    else
      render :new
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @milestone = Milestone.find(params[:id])
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
end
