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
      bot.sync
      s = bot.ranking
      expect(s).to match /ikesatto/
    end
  end

  describe "rookies" do
    def default_rankings(g, scraped_at)
      [{
         :game_id=>g.id,
         :scraped_at=>scraped_at,
         :rank=>1,
         :name=>"ikesatto",
         :score=>5809,
         :title=>"A+",
         :speed=>5.8,
         :correctly=>100.0,
         :time=>28.4,
         :types=>165,
         :failures=>0,
         :questions=>15,
         :date=> Date.parse("2016-02-14")
       },
       {
         :game_id=>g.id,
         :scraped_at=>scraped_at,
         :rank=>2,
         :name=>"momoka",
         :score=>5808,
         :title=>"A",
         :speed=>5.7,
         :correctly=>100.0,
         :time=>28.4,
         :types=>165,
         :failures=>0,
         :questions=>15,
         :date=> Date.parse("2016-02-14")
       }
      ]
    end

    it "should find rookies" do
      g = Game.create!(mytyping_id: 39661, name: "親指シフト練習１ー頻出語句ランキング")
      Ranking.create!(default_rankings(g, Time.parse("2016-02-20 15:20:00")))
      bot = Bot.new
      expect(bot.rookies).to match /no rookies/

      rs = default_rankings(g, Time.parse("2016-02-21 15:20:00"))
      nr = rs.last.dup
      nr[:rank] = 3
      nr[:name] = "hoge"
      rs << nr
      Ranking.create!(rs)
      expect(bot.rookies).to match /hoge/
    end
  end

  describe "updates" do
    def default_rankings(g, scraped_at, date)
      [{
         :game_id=>g.id,
         :scraped_at=>scraped_at,
         :rank=>1,
         :name=>"ikesatto",
         :score=>5809,
         :title=>"A+",
         :speed=>5.8,
         :correctly=>100.0,
         :time=>28.4,
         :types=>165,
         :failures=>0,
         :questions=>15,
         :date=> date
       },
       {
         :game_id=>g.id,
         :scraped_at=>scraped_at,
         :rank=>2,
         :name=>"momoka",
         :score=>5808,
         :title=>"A",
         :speed=>5.7,
         :correctly=>100.0,
         :time=>28.4,
         :types=>165,
         :failures=>0,
         :questions=>15,
         :date=> date
       }
      ]
    end

    it "should find rookies" do
      g = Game.create!(mytyping_id: 39661, name: "親指シフト練習１ー頻出語句ランキング")
      Ranking.create!(default_rankings(g, Time.parse("2016-02-20 15:20:00"), Date.parse("2016-02-20")))

      bot = Bot.new
      expect(bot.updates).to match /no updates/

      rs = default_rankings(g, Time.parse("2016-02-21 15:20:00"), Date.parse("2016-02-20"))
      # updates
      mr = rs.last
      mr[:score] = "12345"
      mr[:date] = Date.parse("2016-02-21")

      # rookie
      nr = rs.last.dup
      nr[:rank] = 3
      nr[:name] = "hoge"
      rs << nr
      Ranking.create!(rs)
      updates = bot.updates
      expect(updates).to match /^Rookie.*hoge.*$/
      expect(updates).to match /^Update.*momoka.*score.*5808.*12345.*$/
    end
  end
end
