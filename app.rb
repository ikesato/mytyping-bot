# -*- coding: utf-8 -*-
$LOAD_PATH << File.dirname(__FILE__)

require 'active_support/time'
require 'sinatra'
require 'sinatra/multi_route'
require 'eventmachine'
require 'slack-notifier'
require 'open-uri'
require 'pp'
require 'db'
require 'bot'


notifier = Slack::Notifier.new "https://hooks.slack.com/services/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"
notifier.ping "Bot started"

bot = Bot.new

EM::defer do
  loop do
    sleep 10.minutes
    #msg = mt.notification_message
    #notifier.ping msg if msg && !msg.empty?
  end
end

get '/heartbeat' do
  "OK"
end

post '/out-going' do
  content_type 'application/json; charset=utf-8'
  STDERR.puts request.body.read
  p params[:text]
  text = params[:text]
  if text =~ /^add (\d+)$/
    response = bot.add(params[:text].to_i)
    response = PP.pp(response, '')
  elsif text =~ /^list$/
    response = bot.list
    response = PP.pp(response, '')
  elsif text =~ /^debug|デバッグ/
    response = {now: Time.now.to_s}
    response = PP.pp(response, '')
  end
  {text: response}.to_json
end
