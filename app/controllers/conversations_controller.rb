class ConversationsController < ApplicationController
  before_filter :find_project

  def index
    @conversations = @project.conversations.order('created_at DESC').limit(10)
    @conversation = @project.conversations.new
  end

  def create
    @conversation = @project.conversations.build(params[:conversation])
    @conversation.user = current_user
    first_reply = @conversation.replies.first
    first_reply.user = current_user
    first_reply.uploads.each do |upload|
      if upload.asset
        upload.user = current_user
        upload.project = @project
      end
    end

    respond_to do |f|
      if @conversation.save
        # Send Notifications
        regex = /@[a-zA-Z0-9._-]+/
        names = @conversation.replies.first.content.scan(regex)
        if names.member? '@all'
          # notify all members
          @project.members.each do |user|
            NotificationMailer.notify_user(user, @conversation).deliver
          end
        else
          names.each do |name|
            user = User.find_by_name(name[1..name.size])
            NotificationMailer.notify_user(user, @conversation).deliver if user
          end
        end
        if params[:xhr]
          f.html { render :layout => false }
        else
          f.html { redirect_to [@project, @conversation] }
        end
        f.js
      else
        f.html { redirect_to @project, :error => 'save failed' }
        f.js { render :text => :error, :status => 500 }
      end
    end
  end

  def show
    @conversation = @project.conversations.find(params[:id])
  end
end
