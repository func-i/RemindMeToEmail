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
    options = base_options.merge({:query => {:lastmodified => update_date.strftime('%Y%m%dT%H%M%S')}}) unless update_date.nil?
    party_response = self.class.get("#{@base_uri}/api/party", options || base_options)

    if party_response["parties"].nil? || party_response["parties"]["person"].nil?
      ApiHistory.create :contacts_downloaded => 0, :api_name => 'CapsuleCRM'
      return
    end

    partyArray = nil
    if party_response["parties"]["person"].is_a?(Array)
      partyArray = party_response["parties"]["person"]
    else
      partyArray = [party_response["parties"]["person"]]
    end

    partyArray.each do |p|
      c = Contact.where(:external_id => p['id']).first
      c = Contact.new if c.nil?

      c.external_id = p['id']
      c.name = "#{p['firstName']} #{p['lastName']}"

      if p["contacts"] && p["contacts"]["email"]
        if p["contacts"]["email"].is_a?(Array)
          c.email = p["contacts"]["email"].first["emailAddress"]
        else
          c.email = p["contacts"]["email"]["emailAddress"]
        end
      end

      tags_response = self.class.get("#{@base_uri}/api/party/#{c.external_id}/tag", base_options)
      if tags_response["tags"] && tags_response["tags"]["tag"]

        itemsArray = nil
        if tags_response["tags"]["tag"].is_a?(Array)
          c.tags = tags_response["tags"]["tag"].join(', ')
        else
          c.tags = tags_response["tags"]["tag"]
        end
      end

      history_response = self.class.get("#{@base_uri}/api/party/#{c.external_id}/history", base_options)
      if history_response["history"] && history_response["history"]["historyItem"]

        itemsArray = nil
        if history_response["history"]["historyItem"].is_a?(Array)
          itemsArray = history_response["history"]["historyItem"]
        else
          itemsArray = [history_response["history"]["historyItem"]]
        end

        itemsArray.each do |h|
          datetime = DateTime.parse(h["entryDate"])
          c.last_email_at = datetime if c.last_email_at.nil? || c.last_email_at < datetime
        end

      end

      c.save
    end

    ApiHistory.create :contacts_downloaded => party_response["parties"]["person"].count, :api_name => 'CapsuleCRM'

  end
end
