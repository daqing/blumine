class IssueAssignmentsController < ApplicationController
  before_filter :must_be_logged_in, :only => :sort

  def sort
    params[:issue].each_with_index do |id, pos|
      IssueAssignment.update_all(['position=?', pos + 1], ['user_id=? AND issue_id=?', current_user.id, id])
    end

    respond_to do |format|
      format.js { render :nothing => true }
    end
  end

end
