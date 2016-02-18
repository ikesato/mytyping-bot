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
    criteria = criteria.where(id: game_id) if game_id
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
    format_ranking(criteria)
  end

  def format_ranking(rankings)
    prev = nil
    header = ["rank,date,score,speed,time,types,failures,name,title"]
    list = []
    rankings.each do |r|
      if prev.nil? || prev != r.game_id
        list << [] unless list.empty?
        list << "*#{r.game.name}* <#{Mytyping.ranking_url(r.game.mytyping_id)}|More>"
        list << header
      end
      list << "#{r.rank},#{r.date},#{r.score},#{r.speed},#{r.time},#{r.types},#{r.failures},#{r.name},#{r.title}"
      prev = r.game_id
    end
    list << "no rankings" if list.empty?
    list.join("\n")
  end
end
