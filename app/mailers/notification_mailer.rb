class NotificationMailer < ActionMailer::Base
  default :from => "hello@blumine.org"

  def notify_user(user, conversation)
    @user = user
    @conversation = conversation
    @url = "https://github.com/daqing/blumine"
    mail(:to => user.email, :subject => "#{user.name} Replied you")
  end
end
