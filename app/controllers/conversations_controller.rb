class ConversationsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @conversation = @project.conversations.build(params[:conversation])
    @conversation.user = current_user

    respond_to do |f|
      if @conversation.save
        f.html { redirect_to @project }
        f.js
      else
        f.html { redirect_to @project, :error => 'save failed' }
        f.js { render :text => :error, :status => 500 }
      end
    end
  end
end
