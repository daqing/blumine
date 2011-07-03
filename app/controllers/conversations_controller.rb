class ConversationsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @conversation = @project.conversations.build(params[:conversation])
    @conversation.user = current_user

    result = @conversation.save
    flash[:error] = 'failed' unless result

    redirect_to @project
  end
end
