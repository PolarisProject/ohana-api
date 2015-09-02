class ContactImporter < EntityImporter
  def valid?
    @valid ||= contacts.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(contacts)
  end

  def import
    contacts.each(&:save)
  end

  protected

  def contacts
    @contacts ||= csv_entries.inject([]) do |result, chunks|
      chunks.each do |row|
        result << ContactPresenter.new(row).to_contact
      end
      result
    end
  end

  def self.required_headers
    %w(id location_id organization_id service_id department email name
       title)
  end
end
