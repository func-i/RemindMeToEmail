class UserMailer < ActionMailer::Base
  default :from => "kvirani@func-i.com"

  def summary_email(contacts)
    @contacts = contacts

    mail(:to => ENV['summary_email_address'].split(','), :subject => "Email Reminders Summary")
  end
end
