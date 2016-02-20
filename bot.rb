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
      rookies = find_rookies(g.id)
      updates = find_updates(g.id)

      # format output
      if rookies.count > 0 || updates.count > 0
        list << [] if list.count > 0
        list << "*#{g.name}* <#{Mytyping.game_url(g.mytyping_id)}|Game> <#{Mytyping.ranking_url(g.mytyping_id)}|Ranking>"
        rookies.each do |r|
          list << "Rookie " + r.slice(:name,:rank,:date,:score,:speed,:time,:types,:failures,:title).to_json
        end
        updates.each do |u|
          list << "Update " + u.to_json
        end
        list << "(scraped at : #{g.last_rankings.first.scraped_at})"
      end
    end
    list << "no updates" if list.empty?
    list.join("\n")
  end

  def rookies
    rs = find_rookies
    format_ranking(rs, "rookies")
  end

  private
  def find_rookies(game_id=nil)
    rookies = []
    gs = Game.all.order(:id)
    gs = gs.where(id: game_id) if game_id
    gs.each do |g|
      newr = g.last_rankings.order(:rank)
      oldr = g.past_rankings.order(:rank)
      newr.each do |r|
        rookies << r unless oldr.where(name: r.name).exists?
      end
    end
    rookies
  end

  def find_updates(game_id=nil)
    updates = []
    gs = Game.all.order(:id)
    gs = gs.where(id: game_id) if game_id
    gs.each do |g|
      newr = g.last_rankings.order(:rank)
      newr.each do |rn|
        g.rankings.where(name: rn.name).order(scraped_at: :desc).each do |ro|
          next if rn.id == ro.id
          next if rn.date == ro.date
          break if rn.scraped_at - ro.scraped_at > 3.days
          ro.attributes = rn.attributes.except("id", "scraped_at", "created_at", "updated_at")
          updates << {"name": rn.name, "rank": rn.rank}.merge(ro.changes)
          break
        end
      end
    end
    updates
  end
end
