require 'active_record'

class Ranking < ActiveRecord::Base
  belongs_to :game

  def self.scrape(mytyping_id)
    mt = Mytyping.new
    list = mt.scrape_ranking(mytyping_id)
    return nil if list.nil?
    now = Time.now
    list.map do |l|
      new(l.merge(scraped_at: now))
    end
  end
end
