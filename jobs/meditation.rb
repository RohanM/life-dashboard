require 'csv'
require 'active_support/time'
require 'pry'

minutes_per_day = {}

CSV.foreach('insight_sessions_export.csv') do |row|
  begin
    started_at = Time.strptime "#{row[0]} +0000", "%m/%d/%Y %H:%M:%S %z"
    duration = row[1]
    activity = row[2]
    preset = row[3]

    minutes_per_day[started_at.to_date] ||= 0
    minutes_per_day[started_at.to_date] += duration.to_i

  rescue ArgumentError, TypeError => e
    # Ignore header row where time doesn't parse
  end
end

points = minutes_per_day.keys.sort.map do |day|
  {x: day.to_time.to_i, y: minutes_per_day[day]}
end

points_last_month = points.select { |p| p[:x] > 1.month.ago.to_i }

send_event('meditation-all-time', points: points)
send_event('meditation-last-month', points: points_last_month)
