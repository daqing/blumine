class TodoItemsController < ApplicationController
  before_filter :must_login_first
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

  def change_state
    event_action = params[:event] + '!'
    respond_to do |format|
      if @todo_item.respond_to? event_action
        begin
          @todo_item.send(event_action)
          format.html { redirect_to [@todo_item.issue.project, @todo_item.issue] }
          format.js { render :nothing => true }
        rescue
          format.html { redirect_to root_path }
          format.js { render :text => "EXCEPTION", :status => 500 }
        end
      else
        format.html { redirect_to root_path }
        format.js { render :text => "ERROR", :status => 500 }
      end
    end
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
end
