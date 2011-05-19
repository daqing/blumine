class ActivitiesController < ApplicationController
  before_filter :must_login_first

  def create
    @activity = Activity.new(:user_id => current_user.id,
                             :event_name => 'chat',
                             :target_type => 'chat',
                             :target_id => 0,
                             :data => params[:activity][:data])
    respond_to do |format|
      if @activity.save
        format.js
      else
        format.js { render :text => 'ERROR', :status => 500 }
      end
    end
  end

end
