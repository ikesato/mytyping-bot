require 'game'
require 'ranking'

class Bot
  def add(mytyping_id)
    g = Game.scrape(mytyping_id)
    return {error: "faled to scpara for #{mytyping_id}"} unless g
    return {error: g.errors.full_messages} unless g.save
    g.as_json
  end

  def list
    Game.all.order(:id).map(&:as_json)
  end
end
