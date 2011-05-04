class TodoItemsController < ApplicationController
  before_filter :must_login_first
  before_filter :find_todo_item, :only => [:change_state, :destroy]

  def create
    @issue = Issue.find(params[:issue_id])
    check_permission(@issue) do
      @todo_item = @issue.todo_items.new(params[:todo_item])

      respond_to do |format|
        if @todo_item.save
          format.html { redirect_to @issue }
          format.js
        else
          format.html { redirect_to @issue }
          format.js { render :nothing => true }
        end
      end
    end
  end

  def change_state
    check_permission(@todo_item.issue) do
      event_action = params[:event] + '!'
      respond_to do |format|
        if @todo_item.respond_to? event_action
          begin
            @todo_item.send(event_action)
            format.html { redirect_to @todo_item.issue }
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
  end

  def destroy
    check_permission(@todo_item.issue) do
      respond_to do |format|
        if @todo_item.destroy
          format.html { redirect_to @todo_item.issue }
          format.js
        else
          format.html { redirect_to root_path }
          format.js { render :text => "Error", :status => 500 }
        end
      end
    end
  end

  def sort
    check_permission(TodoItem.find(params[:todo].first).issue) do
      params[:todo].each_with_index do |id, pos|
        TodoItem.update_all(['position=?', pos + 1], ['id=?', id])
      end

      respond_to do |format|
        format.js { render :nothing => true }
      end
    end
  end

  private
    def find_todo_item
      @todo_item = TodoItem.find(params[:id])
    end

    def check_permission(issue)
      render :text => :error, :status => 403 and return unless current_user.can_manage_todo? issue
      yield if block_given?
    end
end
