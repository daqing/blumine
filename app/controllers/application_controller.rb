class ApplicationController < ActionController::Base
  include ApplicationHelper
  include FaceboxRender

  before_filter :set_locale

  protect_from_forgery

  before_filter :add_initial_breadcrumbs

  private
    def add_initial_breadcrumbs
      breadcrumbs.add t(:home), root_path
    end

    def set_locale
      if current_user
        I18n.locale = current_user.locale
      else
        I18n.locale = params[:locale]
      end
    end
end

