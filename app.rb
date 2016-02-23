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


def help
  <<EOF
_*list*_
  登録タイピング一覧 
_*del <typing_id>*_
  タイピング削除
_*add <myTyping ID>*_
  タイピング追加
_*ranking [typing_id]*_
  ランキング表示 
_*updates*_
  間近３日間の更新表示
_*roukies*_
  間近３日間の新規ユーザー
_*sync*_
  ランキング更新
_*sync-updates*_
  ランキング更新と間近３日間の更新表示
_*settings*_
  設定一覧
_*set <name>=<value>*_
  設定変更
  設定値
  watching_days=<integer>
  keeping_days=<integer>
_*help*_
  show this help
EOF
end

post '/out-going' do
  content_type 'application/json; charset=utf-8'
  p request.body.read
  return {text: nil}.to_json if params[:user_name] == "slackbot"

  p params[:text]
  text = params[:text]
  if text =~ /^\s*add\s+(\d+)\s*$/
    response = bot.add($1.to_i)
    response = PP.pp(response, '')
  elsif text =~ /^\s*list\s*$/
    response = bot.list
    response = PP.pp(response, '')
  elsif text =~ /^\s*ranking/
    game_id = $1.to_i if text =~ /ranking\s+(\d+)\s*$/
    response = bot.ranking(game_id)
  elsif text =~ /^\s*sync\s*$/
    response = bot.sync
    response = PP.pp(response, '')
  elsif text =~ /^\s*rookies\s*$/
    response = bot.rookies
  elsif text =~ /^\s*updates\s*$/
    response = bot.updates
  elsif text =~ /^\s*sync-updates\s*$/
    response = PP.pp(bot.sync, '')
    response += "\n"
    response += bot.updates
  elsif text =~ /^\s*settings\s*$/
    response = bot.settings
  elsif text =~ /^\s*set\s*(.+)=(.+)$/
    response = bot.set($1.strip, $2.strip)
  elsif text =~ /^\s*help\s*$/
    response = help
  elsif text =~ /^debug/
    response = {now: Time.now.to_s}
    response = PP.pp(response, '')
  else
    response = "I can't recognize command. => [#{text}]"
  end
  {text: response}.to_json
end
