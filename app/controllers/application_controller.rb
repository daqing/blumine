class ApplicationController < ActionController::Base
  include ApplicationHelper
  include FaceboxRender

  protect_from_forgery

  before_filter :add_initial_breadcrumbs

  private
    def add_initial_breadcrumbs
      breadcrumbs.add '首页', root_path
    end
end

