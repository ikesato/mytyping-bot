require 'timecop'
require 'active_record'
require 'database_cleaner'
require 'webmock/rspec'

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

end

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'db/test.sqlite'
)
MIGRATIONS_DIR = 'db/migrate'
ActiveRecord::Migrator.migrate(MIGRATIONS_DIR, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
