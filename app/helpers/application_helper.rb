module ApplicationHelper
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_session && current_session.record
  end

  def current_session
    return @current_session if defined?(@current_session)
    @current_session = UserSession.find
  end

  def parse_markdown(text)
    RDiscount.new(h(text)).to_html
  end

  def must_not_logged_in
    redirect_to root_path if current_user
  end

  def must_be_logged_in
    redirect_to root_path if not current_user
  end

  def must_login_first
    if not current_user
      store_location
      flash[:notice] = "请先登录再继续操作"
      redirect_to login_path
    end
  end

  def creator_required(obj)
    unless creator_of?(obj)
      flash[:error] = "您没有权限执行此操作"
      redirect_to root_path 
    end
  end

  def creator_of?(obj)
    obj.user == current_user
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or(path)
    redirect_to session[:return_to] || path
    clear_return_to
  end

  def clear_return_to
    session[:return_to] = nil
  end

  def as_button(str)
    %(<div class="btn_2_o" align="left"><div class="btn_2_i" align="center">#{str}</div></div>).html_safe
  end

  def render_with_spacer(collection)
    class_name = collection.name.downcase
    render :partial => "#{class_name.pluralize}/#{class_name}", 
        :collection => collection,
        :spacer_template => 'shared/spacer'
  end
end
