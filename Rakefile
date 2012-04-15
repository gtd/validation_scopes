begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "validation_scopes"
    gem.summary = %Q{Create sets of validations independent of the life-cycle of an ActiveRecord object}
    gem.description = %Q{Define additional sets of validations beyond the standard "errors" that is tied to the ActiveRecord life-cycle.  These additional sets can be defined with all the standard ActiveRecord::Validation macros, and the resulting collection is a standard ActiveRecord::Errors object.}
    gem.email = "gabe@websaviour.com"
    gem.homepage = "http://github.com/dasil003/validation_scopes"
    gem.authors = ["Gabe da Silveira"]
    gem.add_development_dependency "shoulda", ">= 0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << %w(lib test)
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :test => :check_dependencies

task :default => :test
