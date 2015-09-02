class RegularScheduleImporter < EntityImporter
  def valid?
    @valid ||= regular_schedules.all?(&:valid?)
  end

  def errors
    ImporterErrors.messages_for(regular_schedules)
  end

  def import
    regular_schedules.each(&:save)
  end

  protected

  def regular_schedules
    @regular_schedules ||= csv_entries.inject([]) do |result, chunks|
      chunks.each do |row|
        result << RegularSchedulePresenter.new(row).to_regular_schedule
      end
      result
    end
  end

  def self.required_headers
    %w(id location_id service_id weekday opens_at closes_at)
  end
end
