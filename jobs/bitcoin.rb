require 'net/http'
require 'json'
require 'pry'


def btc_daily_price
  today = Date.today.strftime("%Y-%m-%d")
  url = "https://api.coindesk.com/v1/bpi/historical/close.json?start=2010-07-17&end=#{today}"
  uri = URI(url)
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)

  Hash[
    data['bpi'].map { |date, value|
      [Date.parse(date), value]
    }
  ]
end


def running_mean(data, window_size)
  data.each_cons(window_size).map { |window|
    [
      window.max { |d| d[0] }[0],
      (window.sum { |d| d[1] } / window.length).round(0)
    ]
  }
end


SCHEDULER.every '1d' do
  data = running_mean(btc_daily_price, 200)
  points = data.map { |d| {x: d[0].to_time.to_i, y: d[1]} }

  send_event('bitcoin-running-mean-200', {points: points})
end
