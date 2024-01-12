version = File.read(File.expand_path("../VERSION",__FILE__)).strip

Gem::Specification.new do |s|
  s.name = "validation_scopes"
  s.version = version

  s.authors = ["Gabe da Silveira"]
  s.description = "Define additional sets of validations beyond the standard \"errors\" that is tied to the ActiveRecord life-cycle.  These additional sets can be defined with all the standard ActiveRecord::Validation macros, and the resulting collection is a standard ActiveRecord::Errors object."
  s.email = "gabe@websaviour.com"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    "CHANGELOG.md",
    "LICENSE",
    "README.md",
    "lib/validation_scopes.rb"
  ]
  s.homepage = "http://github.com/gtd/validation_scopes"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.22"

  s.summary = "Create sets of validations independent of the life-cycle of an ActiveRecord object"

  s.required_ruby_version = '>= 1.9.2'

  s.add_dependency 'activerecord', '>= 3', '< 8'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'sqlite3'
end
