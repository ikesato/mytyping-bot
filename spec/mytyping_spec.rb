# -*- coding: utf-8 -*-
require 'spec_helper'
require 'mytyping'
require 'pp'

describe Mytyping do
  describe "scrape_game" do
    it "should scrape correctly" do
      stub_request(:get, "http://typing.twi1.me/game/39679").
        to_return(:body => File.open("spec/game.html").read)
      mt = Mytyping.new
      ret = mt.scrape_game(39679)
      expect(ret).to eq({name: '親指シフト練習２ーホームポジションの練習', mytyping_id: 39679})
    end
  end

  describe "scrape_ranking" do
    it "should scrape correctly" do
      stub_request(:get, "http://typing.twi1.me/ranking?gameId=39679").
        to_return(:body => File.open("spec/ranking.html").read)
      mt = Mytyping.new
      ret = mt.scrape_ranking(39679)

      expect(ret.count).to eq 5
      expect(ret.first).to eq ({
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
        :date=> Date.parse("2016-02-14")})
      expect(ret.last).to eq ({
        :rank=>5,
        :name=>"1226",
        :score=>3841,
        :title=>"D++",
        :speed=>3.9,
        :correctly=>97.9,
        :time=>36.7,
        :types=>144,
        :failures=>3,
        :questions=>15,
        :date=>Date.parse("2015-12-29")})
    end
  end
end
