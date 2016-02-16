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

      expect(ret.count).to eq 9
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
        :rank=>9,
        :name=>"t8295084",
        :score=>2459,
        :title=>"F++",
        :speed=>2.4,
        :correctly=>100.0,
        :time=>67.1,
        :types=>165,
        :failures=>0,
        :questions=>15,
        :date=>Date.parse("2016-02-08")})
    end
  end
end
