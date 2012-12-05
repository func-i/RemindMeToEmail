class ContactsController < ApplicationController
  http_basic_authenticate_with :name => "func-i", :password => "func-i-2012", :except => [:run_api_calls]

  def index
    @ready_to_contact_contacts = Contact.been_contacted_before.need_to_contact.all

    @contacts = Contact.been_contacted_before

    params[:sort_order] ||= 'ASC'
    params[:sort_by] ||= 'name'

    case params[:sort_by]
      when 'last_email_at'
        @contacts = @contacts.order("last_email_at #{params[:sort_order]}")
      when 'tags'
        @contacts = @contacts.order("tags #{params[:sort_order]} NULLS LAST")
      when 'next_reminder'
        @contacts = @contacts.order_by_time_until_next_contact(params[:sort_order])
      else
        @contacts = @contacts.order("LOWER(name) #{params[:sort_order]}")
    end
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
