class CommentsController < ApplicationController
  before_filter :must_login_first
  before_filter :find_comment, :except => :create
  before_filter :only => [:edit, :update, :destroy] do |c|
    authorize! :manage, @comment
  end

  def create
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.new(params[:comment])
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        mb_chars = @comment.content.mb_chars
        Activity.create!(
          :user_id => current_user.id,
          :project_id => @issue.project.id,
          :event_name => 'create_comment',
          :target_id => @issue.id,
          :data => {
            :project_name => @issue.project.name,
            :issue_title => @issue.title,
            :comment_body => mb_chars.length > 20 ? "#{mb_chars[0..20]}..." : @comment.content
          }
        )
        
        format.html { redirect_to @issue }
        format.js
      else
        format.html { redirect_to root_path }
        format.js { render :nothing => true }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html { render 'edit', :layout => false }
    end
  end

  def update
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment.issue }
        format.js
      else
        format.html { redirect_to root_path }
        format.js { render :text => "SAVE_FAILED", :status => 500 }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @comment.destroy
        format.html { redirect_to @comment.issue }
        format.js
      else
        format.html { redirect_to root_path }
        format.js { render :text => "DESTROY_ERROR", :status => 500 }
      end
    end
  end

  private
    def find_comment
      @comment = Comment.find(params[:id])
    end
end
