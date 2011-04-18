class TodoItemsController < ApplicationController
  def create
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
    @todo_item = @issue.todo_items.new(params[:todo_item])

    if @todo_item.save
      redirect_to [@project, @issue]
    else
      # TODO: Error!
      redirect_to root_path
    end
  end

  def destroy
  end

end
