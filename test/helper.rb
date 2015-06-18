require 'minitest/autorun'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'validation_scopes'

puts "Testing against ActiveRecord #{ActiveRecord::VERSION::STRING}"

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:"
)

require 'db/schema.rb'

Dir['./test/models/*.rb'].each { |f| require f }

require 'active_record/fixtures'

fixtures_constant = if defined?(ActiveRecord::FixtureSet)
  ActiveRecord::FixtureSet
elsif defined?(ActiveRecord::Fixtures)
  ActiveRecord::Fixtures
else
  Fixtures
end


fixtures_constant.create_fixtures('test/fixtures/', ActiveRecord::Base.connection.tables)
