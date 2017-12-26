require 'net/http'
require 'json'
require 'active_support/time'
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
      window.sum { |d| d[1] } / window.length
    ]
  }
end

def mayer_multiple(price, running_mean)
  running_mean.map do |mean|
    [
      mean[0],
      price.find { |price| price[0] == mean[0] }[1] / mean[1]
    ]
  end
end

SCHEDULER.every '1d' do
  price = btc_daily_price
  mean = running_mean(btc_daily_price, 200)
  multiple = mayer_multiple(price, mean)

  points_all_time = multiple.map { |d| {x: d[0].to_time.to_i, y: d[1].round(2)} }
  points_6_mo = points_all_time.select { |p| Time.at(p[:x]) > 6.months.ago }

  send_event('bitcoin-mayer-multiple-all-time', {points: points_all_time})
  send_event('bitcoin-mayer-multiple-6-mo', {points: points_6_mo})
end
