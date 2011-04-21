class StatusLogsController < ApplicationController
  before_filter :must_be_logged_in
  
  def create
    @log = current_user.status_logs.new(params[:status_log])

    respond_to do |format|
      if @log.save
        format.js { render :nothing => true }
      else
        format.js { render :text => "CREATE_ERROR", :status => 500 }
      end
    end
  end

  def destroy
    @log = StatusLog.find(params[:id])

    respond_to do |format|
      if @log.destroy
        format.js { render :nothing => true }
      else
        format.js { render :text => "DESTROY_ERROR", :status => 500 }
      end
    end
  end

end
