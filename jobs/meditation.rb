require 'csv'
require 'active_support/time'
require 'pry'

points = []

CSV.foreach('insight_sessions_export.csv') do |row|
  begin
    started_at = Time.strptime "#{row[0]} +0000", "%m/%d/%Y %H:%M:%S %z"
    duration = row[1]
    activity = row[2]
    preset = row[3]

    points << {x: started_at.to_i, y: duration}

  rescue ArgumentError, TypeError => e
    # Ignore header row where time doesn't parse
  end
end

points.reverse!

points_last_month = points.select { |p| p[:x] > 1.month.ago.to_i }

send_event('meditation-all-time', points: points)
send_event('meditation-last-month', points: points_last_month)
