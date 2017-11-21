require 'csv'
require 'active_support/time'
require 'pry'

# Read workouts from map_my_run.csv and draw a graph: "Days between workouts"


SCHEDULER.every '1m' do
  workouts = []
  CSV.foreach('data/map_my_run.csv') do |row|
    next if row[1] == 'Workout Date' # Skip header row
    workouts << {date: Date.parse(row[1]), distance: row[4]}
  end

  recent_workouts = workouts.sort_by {|w| w[:date]}.last(10)

  interval_points = intervals(recent_workouts)

  send_event('map-my-run-intervals', {points: interval_points, graphtype: 'bar'})
end

def intervals(workouts)
  intervals = workouts.each_cons(2).map { |a, b| b[:date] - a[:date] }
  intervals << Date.today - workouts.last[:date]

  intervals.each_with_index.map { |interval, i| {x: i, y: interval.to_i} }
end
