desc "This task is called by the Heroku scheduler add-on"
task :update_from_capsule_crm => :environment do
  puts "Updating contacts from Capsule (func-i, f4f1aab0799124b56ddfed44f59fc6c5)"

  c = CapsuleCRM.new('func-i','f4f1aab0799124b56ddfed44f59fc6c5')
  update_since = ApiHistory.last.created_at - 1.hour if ApiHistory.last
  c.update_contacts_updated_since(update_since || nil)

  puts "Downloaded #{ApiHistory.last.contacts_downloaded} contacts"
end
