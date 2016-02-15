require 'open-uri'
require 'eventmachine'

# Usage:
#   ps = PreventHerokuSleeping.new "https://xxx.herokuapp.com/heartbeat"
#   ps.start


class PreventHerokuSleeping
  DEFAULT_SLEEPING_TIMES = [{start: "23:50", stop: "24:00"},
                            {start: "00:00", stop: "06:30"}]
  def initialize(heroku_url)
    @heroku_url
  end

  def sleeping_times=(times)
    @sleeping_times = times
  end

  def start
    EM::defer do
      loop do
        sleep 3.minutes
        next if going_sleep?
        # polling self to prevent sleeping
        open(heroku_url)
      end
    end
  end

  private
  def going_sleep?
    now = Time.now
    @sleeping_times.each do |s|
      t1 = Time.parse(s[:start])
      t2 = Time.parse(s[:stop])
      if t1 <= now && now < t2
        return true
      end
    end
    false
  end
end
