require 'active_record'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3:db/db.sqlite')
