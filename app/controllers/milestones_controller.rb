class MilestonesController < ApplicationController
  before_filter :must_login_first
  before_filter :find_project, :only => [:new, :create]

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

  private
    def find_project
      @project = Project.find(params[:project_id])
    end
end
