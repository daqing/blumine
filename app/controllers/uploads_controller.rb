class UploadsController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @uploads = @project.uploads
  end
end
