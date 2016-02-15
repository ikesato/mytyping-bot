# -*- coding: utf-8 -*-
require 'open-uri'
require 'nokogiri'


class MyTyping
  def scrape(gameid)
    url = "http://typing.twi1.me/ranking?gameId=#{gameid}"
    #doc = fetch(url)
    doc = fetch_debug
    return nil unless doc
    list = []
    doc.css('table#rankingTable tr').each do |row|
      tds = row.css('td')
      next if tds.length >= 11
      rank = tds[0].text.strip
      
      detail = fetch(a[:href])
      return nil unless detail
      name = detail.css('h1').text.strip
      time = detail.css('.subText').text.strip
      description = detail.css('.trouble').text.strip
      next if name.empty? || time.empty? || description.empty?
      next if time !~ /(\d+)月(\d+)日 (\d+)時(\d+)分更新/
      time = Time.local(Time.now.year, $1.to_i, $2.to_i, $3.to_i, $4.to_i)
      list << {name: name, time: time, description: description, url: a[:href]}
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

  def fetch_debug
    Nokogiri::HTML.parse(File.read("a.html"), nil, 'UTF-8')
  end
end
