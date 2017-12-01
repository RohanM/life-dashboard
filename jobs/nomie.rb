require 'pry'

# Read data from a Nomie backup (JSON) and produce charts from the data. In particular, I'm
# using this to produce charts of "days between events", which I find very useful for keeping
# myself on track for things I want to be doing regularly every few days.
#
# https://nomie.io/

SCHEDULER.every '1m' do |job|
  data = JSON.parse(File.read('data/nomie.json'))
  trackers = load_trackers(data)
  events = load_events(data)

  social_events = events_for_tracker(trackers, events, "Feeling connected / supported")
  interval_points = event_intervals(social_events.last(10))

  send_event('nomie-social-intervals', {points: interval_points, graphtype: 'bar'})
end

def load_trackers(data)
  Hash[
    data['trackers'].map { |tracker|
      [tracker['_id'], tracker]
    }
  ]
end

def load_events(data)
  data['events'].map { |event|
    # The tracker id is stored in the event id, deliniated by '|'s
    tracker_id = event['_id'].split('|')[3]
    event.merge({
      'tracker_id' => tracker_id,
      'time' => Time.at(event['time'] / 1000)
    })
  }
end

def events_for_tracker(trackers, events, tracker_label)
  events.select { |event|
    trackers[event['tracker_id']]['label'] == tracker_label
  }
end

def event_intervals(events)
  intervals = events.each_cons(2).map { |a, b| b['time'].to_date - a['time'].to_date }
  intervals << Date.today - events.last['time'].to_date

  intervals.each_with_index.map { |interval, i| {x: i, y: interval.to_i} }
end
