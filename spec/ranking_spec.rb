# -*- coding: utf-8 -*-
require 'spec_helper'
require 'game'
require 'ranking'

describe Ranking do
  it "should create" do
    expect {
      r = Ranking.create(game_id: 10, rank: 1, name: "hoge", score: 10, title: "A+",
                         speed: 10.1, correctly: 99.9, time: 30.0, types: 160,
                         failures: 2, questions: 5, date: "2016-02-16", scraped_at: Time.now)
      r = Ranking.find(r.id)
      expect(r.game_id).to eq 10
      expect(r.rank).to eq 1
      expect(r.name).to eq "hoge"
      expect(r.score).to eq 10
      expect(r.title).to eq "A+"
      expect(r.speed).to eq 10.1
      expect(r.correctly).to eq 99.9
      expect(r.time).to eq 30.0
      expect(r.types).to eq 160
      expect(r.failures).to eq 2
      expect(r.questions).to eq 5
      expect(r.date).to eq Date.parse("2016-02-16")
    }.to change{Ranking.count}.by(1)
  end

  it "should scrape" do
    stub_request(:get, "http://typing.twi1.me/ranking?gameId=39679").
      to_return(:body => File.open("spec/ranking.html").read)
    rs = Ranking.scrape(39679)

    expect(rs.length).to eq 5
    expect(rs.first.attributes.symbolize_keys.except(:id, :game_id, :created_at, :updated_at, :scraped_at)).to eq ({
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
    expect(rs.last.attributes.symbolize_keys.except(:id, :game_id, :created_at, :updated_at, :scraped_at)).to eq ({
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
