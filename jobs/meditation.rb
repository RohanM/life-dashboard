require 'csv'
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

send_event('meditation-all-time', points: points)
