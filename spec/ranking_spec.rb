# -*- coding: utf-8 -*-
require 'spec_helper'
require 'game'
require 'ranking'

describe Ranking do
  it "should create" do
    expect {
      r = Ranking.create(game_id: 10, rank: 1, name: "hoge", score: 10, title: "A+",
                         speed: 10.1, correctly: 99.9, time: 30.0, types: 160,
                         failures: 2, questions: 5, date: "2016-02-16")
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
end
