class StatusLogsController < ApplicationController
  before_filter :must_be_logged_in

  def create
    @status_log = current_user.status_logs.new(params[:status_log])

    respond_to do |format|
      if @status_log.save
        format.js
      else
        format.js { render :text => "CREATE_ERROR", :status => 500 }
      end
    end
  end

  def destroy
    @status_log = StatusLog.find(params[:id])
    creator_required(@status_log) and return

    respond_to do |format|
      if @status_log.destroy
        format.js
      else
        format.js { render :text => "DESTROY_ERROR", :status => 500 }
      end
    end
  end

end
