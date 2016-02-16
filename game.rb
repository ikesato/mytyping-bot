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
end
