class TodoItemsController < ApplicationController
  before_filter :find_todo_item, :except => :create

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

  def do_it
    workflow_action "do_it"
  end

  def undo
    workflow_action "undo"
  end

  def destroy
    respond_to do |format|
      if @todo_item.destroy
        format.html { redirect_to [@todo_item.issue.project, @todo_item.issue] }
        format.js { render :nothing => true }
      else
        format.html { redirect_to root_path }
        format.js { render :text => "Error", :status => 500 }
      end
    end
  end

  private
    def find_todo_item
      @todo_item = TodoItem.find(params[:id])
    end

    def workflow_action(action)
      respond_to do |format|
        begin
          @todo_item.send(action + '!')
          format.html { redirect_to [@todo_item.issue.project, @todo_item.issue] }
          format.js { render :nothing => true }
        rescue Workflow::NoTransitionAllowed => e
          format.html { redirect_to root_path }
          format.js { render :text => e.message, :status => 500 }
        end
      end
    end
end
