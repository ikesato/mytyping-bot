# -*- coding: utf-8 -*-
require 'spec_helper'
require 'game'
require 'ranking'

describe Game do
  it "should create" do
    expect {
      Game.create(mytyping_id: 1, name: "hello")
    }.to change{Game.count}.by(1)
    g = Game.where(mytyping_id: 1).first
    expect(g.mytyping_id).to eq 1
    expect(g.name).to eq "hello"
  end

  it "should chanin relations to rankings" do
    g = Game.create(mytyping_id: 1, name: "hello")
    expect(g.rankings).to be_empty
    Ranking.create(game_id: g.id, rank: 1, name: "hoge", score: 10, title: "A+",
                   speed: 10.1, correctly: 99.9, time: 30.0, types: 160,
                   failures: 2, questions: 5, date: "2016-02-16", scraped_at: Time.now)
    Ranking.create(game_id: g.id, rank: 2, name: "fuga", score: 9, title: "B",
                   speed: 10.0, correctly: 99.8, time: 31.0, types: 159,
                   failures: 4, questions: 6, date: "2016-02-15", scraped_at: Time.now)
    g = Game.find(g.id)
    expect(g.rankings.length).to eq 2
    expect(g.rankings.where(rank: 1).first.name).to eq "hoge"
    expect(g.rankings.where(rank: 2).first.name).to eq "fuga"
  end

  it "should scrape" do
    stub_request(:get, "http://typing.twi1.me/game/39679").
      to_return(:body => File.open("spec/game.html").read)
    g = Game.scrape(39679)
    expect(g.mytyping_id).to eq 39679
    expect(g.name).to eq "親指シフト練習２ーホームポジションの練習"
  end
end
