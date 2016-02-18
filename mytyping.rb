# -*- coding: utf-8 -*-
require 'open-uri'
require 'nokogiri'


class Mytyping
  def scrape_game(gameid)
    url = "http://typing.twi1.me/game/#{gameid}"
    doc = fetch(url)
    return nil unless doc
    return nil if doc.css('#mainArea h1').length == 0
    name = doc.css('#mainArea h1').text.strip
    {mytyping_id: gameid, name: name}
  end

  def self.ranking_url(gameid)
    "http://typing.twi1.me/ranking?gameId=#{gameid}"
  end

  def scrape_ranking(gameid)
    url = Mytyping.ranking_url(gameid)
    doc = fetch(url)
    return nil unless doc
    list = []
    count = 0
    doc.css('table#rankingTable tr').each do |row|
      tds = row.css('td')
      next if tds.length < 11
      break if (count+=1) > 5
      rank = tds[0].text.strip.to_i
      name = tds[1].text.strip
      score = tds[2].text.strip.to_i
      title = tds[3].text.strip
      speed = tds[4].text.strip.to_f
      correctly = tds[5].text.strip.to_f
      time = tds[6].text.strip.to_f
      types = tds[7].text.strip.to_i
      failures = tds[8].text.strip.to_i
      questions = tds[9].text.strip.to_i
      date = Date.parse(tds[10].text.strip)
      list << {rank: rank, name: name, score: score, title: title, speed: speed,
        correctly: correctly, time: time, types: types, failures: failures,
        questions: questions, date: date}
    end
    list
  end

  private
  def fetch(url)
    charset = nil
    begin
      html = open(url) do |f|
        charset = f.charset if url =~ /^http/
        f.read
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)
    rescue => ex
      puts "Failed to fetch. #{url}"
      puts ex
    end
  end
end
