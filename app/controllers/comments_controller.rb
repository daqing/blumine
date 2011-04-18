class CommentsController < ApplicationController
  def create
    @issue = Issue.find(params[:issue_id])
    @comment = @issue.comments.new(params[:comment])
    @comment.user = current_user

    if @comment.save
      redirect_to @issue
    else
      # TODO: create comment failed !
      redirect_to root_path
    end
  end

end
