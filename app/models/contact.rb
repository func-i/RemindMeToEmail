class Contact < ActiveRecord::Base

  scope :need_to_contact, lambda {
    where("date_part('days', now() - last_email_at) > days_before_reminder").order('last_email_at ASC')
  }

  scope :been_contacted_before, lambda{ where("last_email_at IS NOT NULL") }

end
