class TodoItemsController < ApplicationController
  def create
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
    @todo_item = @issue.todo_items.new(params[:todo_item])

    respond_to do |format|
      if @todo_item.save
        format.html { redirect_to [@project, @issue] }
        format.js
      else
        format.html { redirect_to [@project, @issue] }
        format.js { render :nothing => true }
      end
    end
  end

  def destroy
  end

end
