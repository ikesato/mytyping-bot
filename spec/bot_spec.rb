# -*- coding: utf-8 -*-
require 'spec_helper'
require 'bot'
require 'pp'

describe Bot do
  describe "format_ranking" do
    it "should format raking datas" do
      stub_request(:get, "http://typing.twi1.me/ranking?gameId=39661").
        to_return(:body => File.open("spec/ranking-39661.html").read)
      stub_request(:get, "http://typing.twi1.me/ranking?gameId=39683").
        to_return(:body => File.open("spec/ranking-39683.html").read)
      Game.create!(mytyping_id: 39661, name: "親指シフト練習１ー頻出語句ランキング")
      Game.create!(mytyping_id: 39683, name: "親指シフト練習６ー半濁音の徹底マスター")
      bot = Bot.new
      s = bot.retrieve_ranking
      expect(s).to match /ikesatto/
    end
  end
end
