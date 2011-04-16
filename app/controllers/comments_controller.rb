class CommentsController < ApplicationController
  def create
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.new(params[:comment])
    @comment.user = current_user

    if @comment.save
      redirect_to @issue
    else
      # create comment failed !
    end
  end

end
