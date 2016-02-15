# -*- coding: utf-8 -*-
$LOAD_PATH << File.dirname(__FILE__)

require 'active_support/time'
require 'sinatra'
require 'sinatra/multi_route'
require 'eventmachine'
require 'slack-notifier'
require 'open-uri'
require 'pp'

last_synced_at = Time.now

notifier = Slack::Notifier.new "https://hooks.slack.com/services/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"
notifier.ping "Bot started"

mt = MyTyping.new

EM::defer do
  loop do
    sleep 10.minutes
    mt.sync
    msg = mt.notification_message
    notifier.ping msg if msg && !msg.empty?
    last_synced_at = Time.now
  end
end

get '/heartbeat' do
  "OK"
end

get '/force-sync' do
  mt.sync
  "OK"
end

post '/out-going' do
  content_type 'application/json; charset=utf-8'
  p request.body.read
  p params[:text]
  text = params[:text]
  if text =~ /^今の天気/
    cw = weather.current_wheather
    response = cw ? (cw.fine? ? "晴れ" : "雨") : "不明"
  elsif text =~ /^今の通知は？/
    response = weather.notification_message(ignore_sended: true)
  elsif text =~ /^debug|デバッグ/
    json = {now: Time.now.to_s, last_synced_at: last_synced_at, counter: counter, weather: weather.weather, notifications: weather.notifications}
    response = PP.pp(json, '')
  end
  {text: response}.to_json
end


# For debug
get '/debug/now' do
  Time.now.to_s
end

get '/debug/weather' do
  content_type 'text/plain'
  PP.pp(weather.weather, '')
end

get '/debug/notifications' do
  content_type 'text/plain'
  PP.pp(weather.notifications, '')
end

get '/debug/counter' do
  counter.to_s
end
