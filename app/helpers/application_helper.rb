module ApplicationHelper
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_session && current_session.record
  end

  def current_session
    return @current_session if defined?(@current_session)
    @current_session = UserSession.find
  end
end
