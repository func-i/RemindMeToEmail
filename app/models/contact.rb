class Contact < ActiveRecord::Base

  scope :need_to_contact, lambda {
    where("date_part('days', now() - last_email_at) > days_before_reminder").order('last_email_at ASC')
  }

  scope :been_contacted_before, lambda{ where("last_email_at IS NOT NULL") }

  scope :been_contacted_before_or_tagged, lambda{ where("last_email_at IS NOT NULL OR tags IS NOT NULL") }


  scope :order_by_time_until_next_contact, lambda{ |sort_order = "ASC"|
    order("days_before_reminder - date_part('days', now() - last_email_at) #{sort_order} NULLS LAST")
  }

end
