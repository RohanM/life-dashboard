# Read workouts from map_my_run.csv and draw a graph: "Days between workouts"

require 'csv'
require 'active_support/time'
require 'pry'

workout_dates = []
CSV.foreach('map_my_run.csv') do |row|
  next if row[1] == 'Workout Date' # Skip header row
  workout_dates << Date.parse(row[1])
end

recent_workouts = workout_dates.sort.last(10)

intervals = recent_workouts.each_cons(2).map { |a, b| b - a }
intervals << Date.today - recent_workouts.last

points = intervals.each_with_index.map { |interval, i| {x: i, y: interval.to_i} }

send_event('map-my-run-intervals', {points: points, graphtype: 'bar'})
