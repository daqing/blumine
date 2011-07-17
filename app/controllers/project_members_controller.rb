class ProjectMembersController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @members = @project.members
  end
end
