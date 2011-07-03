class RepliesController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @conversation = @project.conversations.find(params[:conversation_id])
    @reply = @conversation.replies.build(params[:reply])
    @reply.user = current_user

    respond_to do |f|
      if @reply.save
        f.html { redirect_to @project }
        f.js
      else
        f.html { redirect_to @project, :error => 'save failed'}
        f.js { render :text => :error, :status => 500 }
      end
    end
  end
end
