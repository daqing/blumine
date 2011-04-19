class CommentsController < ApplicationController
  before_filter :must_login_first

  def create
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.new(params[:comment])
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to [@issue.project, @issue] }
        format.js
      else
        format.html { redirect_to root_path }
        format.js { render :nothing => true }
      end
    end
  end

end
