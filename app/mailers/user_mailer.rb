class UserMailer < ActionMailer::Base
  default :from => "summary@EmailReminders.com"

  def summary_email(contacts)
    @contacts = contacts

    mail(:to => ENV['summary_email_address'], :subject => "Email Reminders Summary")
  end
end
