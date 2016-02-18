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

  def retrieve_ranking(game_id = nil)
    criteria = Game.all
    criteria = criteria.where(game_id: game_id) if game_id
    criteria.each do |g|
      rs = Ranking.scrape(g.mytyping_id)
      rs.each do |r|
        r.game_id = g.id
        return {error: r.errors.full_messages} unless r.save
      end
    end
    ranking(game_id)
  end

  def ranking(game_id = nil)
    criteria = Ranking.all.order(:game_id, :rank)
    criteria = criteria.where(game_id: game_id) if game_id
    criteria.as_json
  end
end
