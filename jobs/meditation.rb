require 'csv'
require 'active_support/time'
require 'pry'

SCHEDULER.every '1m' do
  minutes_per_day = {}
  minutes_per_month = {}

  CSV.foreach('data/insight_sessions_export.csv') do |row|
    begin
      started_at = Time.strptime "#{row[0]} +0000", "%m/%d/%Y %H:%M:%S %z"
      duration = row[1]
      activity = row[2]
      preset = row[3]

      minutes_per_day[started_at.to_date] ||= 0
      minutes_per_day[started_at.to_date] += duration.to_i

      minutes_per_month[started_at.beginning_of_month.to_date] ||= 0
      minutes_per_month[started_at.beginning_of_month.to_date] += duration.to_i

    rescue ArgumentError, TypeError => e
      # Ignore header row where time doesn't parse
    end
  end

  points_monthly = minutes_per_month.keys.sort.map do |month|
    {x: month.to_time.to_i, y: minutes_per_month[month] / Time.days_in_month(month.month, month.year)}
  end

  points_daily = minutes_per_day.keys.sort.map do |day|
    {x: day.to_time.to_i, y: minutes_per_day[day]}
  end

  points_last_year = points_monthly.select { |p| p[:x] >= 1.year.ago.to_i }
  points_last_month = points_daily.select { |p| p[:x] >= 1.month.ago.to_i }
  points_last_week = points_daily.select { |p| p[:x] >= 1.week.ago.to_i }

  # -- Show days with no record
  (1..7).each do |days_ago|
    day = days_ago.days.ago.beginning_of_day.to_i
    unless points_last_week.find { |p| p[:x] == day }
      points_last_week << {x: day, y: 0}
    end
  end
  points_last_week = points_last_week.sort_by {|p| p[:x]}

  send_event('meditation-last-year', {points: points_last_year})
  send_event('meditation-last-month', {points: points_last_month, graphtype: 'bar'})
  send_event('meditation-last-week', {points: points_last_week, graphtype: 'bar'})
end
