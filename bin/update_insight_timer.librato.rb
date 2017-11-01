require 'librato/metrics'
require 'csv'
require 'time'
require 'pry'

# -- Authenticate
Librato::Metrics.authenticate '', ''


# -- Check latest metric
metrics = Librato::Metrics.metrics name: 'meditation'
# TODO: ...

# -- Upload more recent readings
queue = Librato::Metrics::Queue.new
CSV.foreach('insight_sessions_export.csv') do |row|
  begin
    started_at = Time.strptime "#{row[0]} +0000", "%m/%d/%Y %H:%M:%S %z"
    duration = row[1]
    activity = row[2]
    preset = row[3]

    #puts "#{started_at.in_time_zone('Melbourne')} - #{duration} - #{activity} - #{preset}"

    started_at = started_at.localtime("+11:00")

    if started_at.to_i > Librato::Metrics::MIN_MEASURE_TIME
      queue.add meditation: {time: started_at, value: duration, tags: {activity: activity, preset: preset}}
    else
      puts "Skipping old entry: #{started_at}"
    end

  rescue ArgumentError, TypeError => e
    # Ignore header row where time doesn't parse
    puts "Skipping #{row[0]}"
  end
end

queue.submit
