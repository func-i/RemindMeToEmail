class ContactsController < ApplicationController

  def index
    @contacts = Contact.order(:name).all
    @ready_to_contact_contacts = Contact.ready_to_contact.all
  end

  def update
    c = Contact.find params[:id]
    c.update_attributes params[:contact]
    render :nothing => true
  end

  def run_api_calls
    puts "Updating contacts from Capsule (func-i, f4f1aab0799124b56ddfed44f59fc6c5)"

    c = CapsuleCRM.new('func-i','f4f1aab0799124b56ddfed44f59fc6c5')
    update_since = ApiHistory.last.created_at - 1.hour if ApiHistory.last
    c.update_contacts_updated_since(update_since || nil)

    puts "Downloaded #{ApiHistory.last.contacts_downloaded} contacts"

    render :text => "Downloaded #{ApiHistory.last.contacts_downloaded} contacts"
  end
end
