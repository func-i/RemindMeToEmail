desc "This task is called by the Heroku scheduler add-on"
task :update_from_capsule_crm => :environment do
  puts "Updating contacts from Capsule (func-i, #{ENV['capsule_key']})"

  c = CapsuleCRM.new('func-i',ENV['capsule_key'])
  update_since = ApiHistory.last.created_at - 1.hour if ApiHistory.last
  c.update_contacts_updated_since(update_since || nil)

  puts "Downloaded #{ApiHistory.last.contacts_downloaded} contacts"
end

task :send_summary_email => :environment do
  puts "Sending Summary Email"

  contacts = Contact.been_contacted_before_or_tagged.need_to_contact.order_by_time_until_next_contact.all

  UserMailer.summary_email(contacts).deliver
end
