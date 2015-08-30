class CategoryImporter < EntityImporter
  def valid?
    @valid ||= categories.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(categories)
  end

  def import
    categories.each(&:save)
  end

  protected

  def categories
    @categories ||= csv_entries.inject([]) do |result, chunks|
      chunks.each do |row|
        result << CategoryPresenter.new(row).to_category
      end
      result
    end
  end

  def self.required_headers
    %w(taxonomy_id name parent_id parent_name)
  end
end
