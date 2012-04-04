require 'rubygems'
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

# Ruby 1.9.3 -> './test/...' not 'test/...'
Dir['./test/models/*.rb'].each { |f| require f }

require 'active_record/fixtures'
Fixtures.create_fixtures('test/fixtures/', ActiveRecord::Base.connection.tables)