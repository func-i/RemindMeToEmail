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
end
