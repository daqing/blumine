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
    Redcarpet.new(h(text)).to_html
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
    redirect_to_root_when_no_permission unless creator_of? obj
  end

  def redirect_to_root_when_no_permission
    flash[:notice] = t('permission.no_permission')
    redirect_to root_path 
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

  def render_with_spacer(partial, collection)
    render :partial => "#{partial.pluralize}/#{partial}", 
        :collection => collection,
        :spacer_template => 'shared/spacer'
  end

  def update_status!(log)
    current_user.status_logs.create!(:content => log)
  end

  def close_facebox
    %($.facebox.close()).html_safe
  end

  def success_do(action_sym)
    I18n.t(action_sym) + I18n.t('action.successfully')
  end

  def failed_do(action_sym)
    I18n.t(action_sym) + I18n.t('action.failed')
  end

  def issue_title_link(issue)
    title = issue.title 
    if title.mb_chars.length > 20 
      link_to "#{title.mb_chars[0..20].to_s}...", issue, :title => title
    else 
      link_to title, issue 
    end 
  end

  def format_activity(activity)
    case activity.event_name
      when 'create_project': "#{t('activity.create_project')} #{link_to activity.data['name'], url_for(:controller => :projects, :action => :show, :id => activity.target_id)}"
      when 'create_issue'
        issue_url = link_to activity.data['title'], url_for(:controller => :issues, :action => :show, :id => activity.target_id)
        project_url = t('activity.in_project', :url => link_to(activity.data['related_name'], url_for(:controller => :projects, :action => :show, :id => activity.related_id)))
        if I18n.locale == :zh
          "#{project_url}#{t('activity.create_issue')} #{issue_url}"
        else
          "#{t('activity.create_issue')} #{issue_url} #{project_url}"
        end
    end
  end
end
