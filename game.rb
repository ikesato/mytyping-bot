require 'active_record'
require 'mytyping'

class Game < ActiveRecord::Base
  has_many :rankings

  def self.scrape(mytyping_id)
    mt = Mytyping.new
    h = mt.scrape_game(mytyping_id)
    return nil if h.nil?
    new(name: h[:name], mytyping_id: h[:mytyping_id])
  end

  def as_json(options={})
    options = {} if options.blank?
    options[:except] = [] if options[:except].blank?
    options[:except] += [:created_at, :updated_at]
    super(options)
  end

  def last_rankings
    maxt = rankings.maximum(:scraped_at)
    rankings.where(scraped_at: maxt)
  end

  def past_rankings
    t = rankings.where("scraped_at >= ?", 3.day.ago).minimum(:scraped_at)
    rankings.where(scraped_at: t)
  end
end
