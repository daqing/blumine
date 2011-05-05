class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_filter :set_locale

  protect_from_forgery

  before_filter :add_initial_breadcrumbs

  private
    def add_initial_breadcrumbs
      breadcrumbs.add t(:home), root_path
    end

    def set_locale
      if not session[:locale]
        session[:locale] = I18n.default_locale
      end

      if params[:locale]
        session[:locale] = params[:locale]
      elsif current_user
        session[:locale] = current_user.locale
      end

      I18n.locale = session[:locale]
    end
end

