class Contact < ActiveRecord::Base

  scope :ready_to_contact, lambda {
    where("date_part('days', now() - last_email_we_sent_at) > days_before_reminder").order('last_email_we_sent_at ASC')
  }

end
