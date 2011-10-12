module ApplicationHelper
  def gravatar_for(email, options = {})
    options = {:alt => 'avatar', :class => 'avatar', :size => 80}.merge! options
    id = Digest::MD5::hexdigest email.strip.downcase
    url = 'http://www.gravatar.com/avatar/' + id + '.jpg?s=' + options[:size].to_s
    options.delete :size
    image_tag url, options
  end

  def icon(name)
    image_tag "#{name}.png", :height => 16, :width => 16, :align => :absmiddle
  end

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

  def parse_status_log(content)
    links = h(content).gsub(/(http[s]?:\/\/[a-zA-Z?=.]+)/) { %(<a href="#{$1}">#{$1}</a>) }
    links.gsub(/#issue-(\d+)/) do
      issue = Issue.select('title').find($1)
      %(<a href="/issues/#{$1}/" title="#{h(issue.title)}" class="tiptip">#issue-#{$1}</a>)
    end
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
      flash[:notice] = t(:must_login_first)
      redirect_to root_path
    end
  end

  def creator_required(obj)
    redirect_to_root_when_no_permission unless creator_of? obj
  end

  def root_required
    redirect_to_root_when_no_permission unless current_user.root?
  end

  def redirect_to_root_when_no_permission
    flash[:error] = t('access_denied')
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

  def success_do(action_sym)
    I18n.t(action_sym) + I18n.t('action.successfully')
  end

  def failed_do(action_sym)
    I18n.t(action_sym) + I18n.t('action.failed')
  end
  
  def short_title(title)
    max_length = 15
    if title.mb_chars.length > max_length
      title = title.mb_chars[0..max_length].to_s + '...'
    end
    title
  end

  def issue_title_link(issue, *css_class)
    title = issue.title
    link_to short_title(title), issue, :title => title, :class => css_class
  end

  def format_activity(activity)
    case activity.event_name
      when 'create_project'
        "#{t('activity.create_project')} #{link_to activity.data['name'], url_for(:controller => :projects, :action => :show, :id => activity.project_id)}"
      when 'create_issue'
        issue_url = link_to short_title(activity.data['title']), url_for(:controller => :issues, :action => :show, :id => activity.target_id)
        project_url = t('activity.in_project', :url =>
                        link_to(activity.data['project_name'],
                                url_for(:controller => :projects, :action => :show, :id => activity.project_id)
                               )
                       )
        locale_str = "activity.create_issue.#{activity.data['label']}"
        if I18n.locale == :zh
          "#{project_url}#{t(locale_str)} #{issue_url}"
        else
          "#{t(locale_str)} #{issue_url} #{project_url}"
        end
      when 'assign_issue'
        issue_url = link_to short_title(activity.data['issue_title']), url_for(:controller => :issues, :action => :show, :id => activity.target_id)
        user_url = link_to activity.data['assigned_name'], url_for(:controller => :users, :action => :show, :id => activity.data['assigned_id'])
        t('activity.assigned_issue_to', {:issue_url => issue_url, :user_url => user_url})
      when 'change_issue_state'
        issue_url = link_to short_title(activity.data['issue_title']), url_for(:controller => :issues, :action => :show, :id => activity.target_id)
        current_state = activity.data['current_state']
        t('activity.changed_issue_state_as', {:issue_url => issue_url, :state => %(<span class="state state-#{current_state}">#{Issue.state_name(current_state)}</span>)})
      when 'create_comment'
        issue_url = link_to short_title(activity.data['issue_title']), url_for(:controller => :issues, :action => :show, :id => activity.target_id)
        t('activity.commented_on_issue', :issue_url => issue_url) + "<blockquote>&gt;&nbsp;#{h(activity.data['comment_body'])}</blockquote>"
      when 'create_document'
        project_url = t('activity.in_project', :url =>
                        link_to(activity.data['project_name'],
                                url_for(:controller => :projects, :action => :show, :id => activity.project_id)
                               )
                       )
        document_url = link_to short_title(activity.data['document_title']), url_for(:controller => :documents, :action => :show, :id => activity.target_id, :project_id => activity.project_id)
        project_url + t('activity.create_document', :document_url => document_url)
      when 'chat'
        h(activity.data)
    end
  end

  def target_url_after_login
    project_count = Project.count
    if project_count == 0
      new_project_path
    elsif project_count == 1
      project_path(Project.first)
    elsif project_count > 1
      projects_path
    end
  end
end
