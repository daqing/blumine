class VersionsController < ApplicationController
  before_filter :must_login_first
  before_filter :find_project
  
  def index
    @versions = @project.versions

    breadcrumbs.add h(@project.name), project_path(@project)
  end

  def new
    @version = @project.versions.new
  end

  def create
    @version = @project.versions.build(params[:version])
    if @version.save
      redirect_to project_versions_path(@project)
    else
      render :new
    end
  end

  private
    def find_project
      @project = Project.find(params[:project_id])
    end

end
