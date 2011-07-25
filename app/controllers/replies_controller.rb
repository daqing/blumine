class RepliesController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @conversation = @project.conversations.find(params[:conversation_id])
    @reply = @conversation.replies.build(params[:reply])
    @reply.user = current_user

    @reply.uploads.each do |upload|
      upload.user = current_user
      upload.project = @project
    end

    respond_to do |f|
      if @reply.save
        f.html { redirect_to [@project, @conversation] }
        f.js
      else
        f.html {
          flash[:error] = t('error.save_failed')
          redirect_to @project
        }

        f.js { render :text => :error, :status => 500 }
      end
    end
  end
end
