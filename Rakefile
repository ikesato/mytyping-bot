# -*- coding: utf-8 -*-
$LOAD_PATH << File.dirname(__FILE__)

require 'active_record'
require 'yaml'
require 'erb'
require 'logger'
require 'db'

namespace :db do
  MIGRATIONS_DIR = 'db/migrate'

  # outpt logs
  ActiveRecord::Base.logger = Logger.new(STDOUT)

  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Migrator.migrate(MIGRATIONS_DIR, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end

  desc 'Roll back the database schema to the previous version'
  task :rollback do
    ActiveRecord::Migrator.rollback(MIGRATIONS_DIR, ENV['STEP'] ? ENV['STEP'].to_i : 1)
  end
end
