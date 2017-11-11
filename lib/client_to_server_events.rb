require 'sinatra'

# Sometimes we want two-way communciation between a widget and the server. Smashing only
# supports one-way communication, where the server pushes events up to the widget. Here
# we add a new endpoint that can receive events from widgets and broadcast them out to
# listeners.

EVENT_LISTENERS = {}

post '/events' do
  # TODO: Authentication

  request.body.rewind
  body = JSON.parse(request.body.read)

  broadcast_event body['event'], body

  status 200
end


def broadcast_event(event, data)
  (EVENT_LISTENERS[event] || []).each do |listener|
    listener.call data
  end
end

def on_event(event, &block)
  EVENT_LISTENERS[event] ||= []
  EVENT_LISTENERS[event] << block
end
