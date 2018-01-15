require 'csv'

class Report < ApplicationRecord
  def self.to_csv
    attributes = %w{date_of_call caller_id category city zip screen post_screen total_duration disposition payout}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |report|
        csv << attributes.map{ |attr| report.send(attr) }
      end
    end
  end

  def name
    "#{date_of_call} #{caller_id}"
  end
end
