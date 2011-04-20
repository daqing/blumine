class CommentsController < ApplicationController
  before_filter :must_login_first

  def create
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.new(params[:comment])
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @issue }
        format.js
      else
        format.html { redirect_to root_path }
        format.js { render :nothing => true }
      end
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment.issue }
        format.js { render :nothing => true }
      else
        format.html { redirect_to root_path }
        format.js { render :text => "SAVE_FAILED", :status => 500 }
      end
    end
  end

end
