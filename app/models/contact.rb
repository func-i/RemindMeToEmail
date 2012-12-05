class Contact < ActiveRecord::Base

  scope :ready_to_contact, lambda {
    where("date_part('days', now() - last_email_at) > days_before_reminder").order('last_email_at ASC')
  }

end
