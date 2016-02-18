source 'https://rubygems.org'

ruby "2.3.0"

gem 'sinatra'
gem 'sinatra-contrib'
gem 'eventmachine'
gem 'slack-notifier'
gem 'activesupport'
gem 'nokogiri'
gem 'activerecord'
gem 'rake'

group :production do
  gem 'pg'
end
group :development, :test do
  gem 'sqlite3'
  gem 'rspec'
  gem 'timecop'
  gem 'database_cleaner'
  gem 'webmock'
  gem 'byebug'
end
