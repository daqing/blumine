class SuperuserController < ApplicationController
  before_filter :must_login_first
  before_filter :root_required
end
