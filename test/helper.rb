require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'validation_scopes'

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:"
)

require 'db/schema.rb'

Dir['./test/models/*.rb'].each { |f| require f }

require 'active_record/fixtures'

fixtures_constant = defined?(ActiveRecord::Fixtures) ? ActiveRecord::Fixtures : Fixtures

fixtures_constant.create_fixtures('test/fixtures/', ActiveRecord::Base.connection.tables)
