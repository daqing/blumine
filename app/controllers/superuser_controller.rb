class SuperuserController < ApplicationController
  layout 'sudo'

  before_filter :must_login_first
  before_filter :root_required
end
