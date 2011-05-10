class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_filter :set_locale
  before_filter :count_unread_teamtalk

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

    def count_unread_teamtalk
      if cookies[:teamtalk_last_open]
        @teamtalk_unread_count = StatusLog.where(['created_at >= ? and user_id != ?',
                                                 DateTime.parse(cookies[:teamtalk_last_open]),
                                                 current_user.id]).limit(10).size
      else
        @teamtalk_unread_count = 0
      end
    end
end

