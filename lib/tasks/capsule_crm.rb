class CapsuleCRM
  include HTTParty
  format :xml

  def initialize(org_name, auth_token)
    @auth = {:user_name => auth_token, :password => 'x'}
    @base_uri = "https://#{org_name}.capsulecrm.com"
    self.class.basic_auth auth_token, 'x'
  end

  def update_contacts_updated_since(update_date = nil)
    base_options = {:format => :xml}

    #query all users that have been updated since update_date
    options = base_options.merge({"lastmodified" => update_date}) unless update_date.nil?
    party_response = self.class.get("#{@base_uri}/api/party", options || base_options)

    party_response["parties"]["person"].each do |p|
      c = Contact.where(:foreign_id => p['id']).first
      c = Contact.new if c.nil?

      c.foreign_id = p['id']
      c.name = "#{p['firstName']} #{p['lastName']}"

      if p["contacts"] && p["contacts"]["email"]
        if p["contacts"]["email"].is_a?(Array)
          c.email = p["contacts"]["email"].first["emailAddress"]
        else
          c.email = p["contacts"]["email"]["emailAddress"]
        end
      end

      history_response = self.class.get("#{@base_uri}/api/party/#{c.foreign_id}/history", base_options)

      if history_response["history"] && history_response["history"]["historyItem"]

        itemsArray = nil
        if history_response["history"]["historyItem"].is_a?(Array)
          itemsArray = history_response["history"]["historyItem"]
        else
          itemsArray = [history_response["history"]["historyItem"]]
        end

        itemsArray.each do |h|
          datetime = DateTime.parse(h["entryDate"])
          c.last_email_we_sent_at = datetime if c.last_email_we_sent_at.nil? || c.last_email_we_sent_at < datetime
        end

      end

      c.save
    end

    ApiHistory.create :contacts_downloaded => party_response["parties"]["person"].count, :api_name => 'CapsuleCRM'

  end
end
