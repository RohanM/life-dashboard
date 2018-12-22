require 'csv'
require 'active_support/time'
require 'pry'

# Read workouts from map_my_run.csv and draw a graph: "Days between workouts"

SCHEDULER.every '1m' do
  workouts = []
  CSV.foreach('data/map_my_run.csv') do |row|
    next if row[1] == 'Workout Date' # Skip header row
    workouts << {date: Date.parse(row[1]), distance: row[4].to_f, avg_pace: row[6].to_f}
  end

  km_per_month_points = monthly_km_points(workouts)
  km_per_month_points.select! { |p| p[:x] >= 1.year.ago.to_i }

  recent_workouts = workouts.sort_by {|w| w[:date]}.last(10)

  interval_points = intervals(recent_workouts)
  pace_points = paces(recent_workouts)

  send_event('map-my-run-monthly', {points: km_per_month_points})
  send_event('map-my-run-intervals', {points: interval_points, graphtype: 'bar'})
  send_event('map-my-run-pace', {points: pace_points, y_min: 4.75})
end

def monthly_km_points(workouts)
  km_per_month = workouts.inject({}) do |kpm, workout|
    month = workout[:date].beginning_of_month.to_date
    kpm[month] ||= 0
    kpm[month] += workout[:distance]
    kpm
  end

  km_per_month.keys.sort.map do |month|
    {x: month.to_time.to_i, y: km_per_month[month]}
  end
end

def intervals(workouts)
  intervals = workouts.each_cons(2).map { |a, b| b[:date] - a[:date] }
  intervals << Date.today - workouts.last[:date]

  intervals.each_with_index.map { |interval, i| {x: i, y: interval.to_i} }
end

def paces(workouts)
  workouts.map { |w| {x: w[:date].to_time.to_i, y: w[:avg_pace]} }
end
