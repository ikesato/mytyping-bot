require 'game'
require 'ranking'

class Bot
  def add(mytyping_id)
    g = Game.scrape(mytyping_id)
    return {result: :ng, error: "faled to scpara for #{mytyping_id}"} unless g
    return {result: :ng, error: g.errors.full_messages} unless g.save
    g.as_json
  end

  def list
    Game.all.order(:id).map(&:as_json)
  end

  def ranking(game_id = nil)
    gs = Game.all.order(:id)
    gs = gs.where(id: game_id) if game_id
    list = []
    gs.each do |g|
      list += g.last_rankings.order(:rank).to_a
    end
    format_ranking(list.compact)
  end

  def format_ranking(rankings, title="rankings")
    prev = nil
    header = ["rank,date,score,speed,time,types,failures,name,title"]
    footer = nil
    list = []
    rankings.each do |r|
      if prev.nil? || prev != r.game_id
        unless list.empty?
          list << footer
          list << []
        end
        list << "*#{r.game.name}* <#{Mytyping.game_url(r.game.mytyping_id)}|Game> <#{Mytyping.ranking_url(r.game.mytyping_id)}|Ranking>"
        list << header
        footer = "(scraped at : #{r.scraped_at})"
      end
      list << "#{r.rank},#{r.date},#{r.score},#{r.speed},#{r.time},#{r.types},#{r.failures},#{r.name},#{r.title}"
      prev = r.game_id
    end
    list << (list.empty? ? "no #{title}" : footer)
    list.join("\n")
  end

  def sync
    count = 0
    games = 0
    Game.all.each do |g|
      games += 1
      rs = Ranking.scrape(g.mytyping_id)
      rs.each do |r|
        r.game_id = g.id
        count += 1
        return {result: :ng, error: r.errors.full_messages} unless r.save
      end
    end
    deleted = Ranking.destroy_all(["scraped_at <= ?", 10.day.ago])
    {result: :success, games: games, updates: count, deleted: deleted.count}
  end

  def updates
    list = []
    Game.all.each do |g|
      roukies = find_roukies

      # search updates
      newr = g.last_rankings.order(:rank)
      oldr = g.past_rankings.order(:rank)
      updates = []
      newr.each do |rn|
        ro = oldr.where(name: rn.name).first
        next unless ro
        next if rn.date == ro.date
        ro.attributes = rn.attributes.except("id", "scraped_at", "created_at", "updated_at")
        updates << {"name": rn.name, "rank": rn.rank}.merge(ro.changes)
      end

      # format output
      if roukies.count > 0 || updates.count > 0
        list << [] if list.count > 0
        list << "*#{g.name}* <#{Mytyping.game_url(g.mytyping_id)}|Game> <#{Mytyping.ranking_url(g.mytyping_id)}|Ranking>"
        roukies.each do |r|
          list << "Roukie " + r.slice(:name,:rank,:date,:score,:speed,:time,:types,:failures,:title).to_json
        end
        updates.each do |u|
          list << "Update " + u.to_json
        end
        footer = "(scraped at : #{newr.first.scraped_at})"
      end
    end
    list << "no updates" if list.empty?
    list.join("\n")
  end

  def roukies
    rs = find_roukies
    format_ranking(rs, "roukies")
  end

  private
  def find_roukies
    roukies = []
    Game.all.each do |g|
      newr = g.last_rankings.order(:rank)
      oldr = g.past_rankings.order(:rank)

      # search roukie
      roukies = []
      newr.each do |r|
        roukies << r if oldr.where(name: r.name).count == 0
      end
    end
    roukies
  end
end
