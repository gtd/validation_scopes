Gem::Specification.new do |s|
  s.name = "validation_scopes"
  s.version = "0.4.1"

  s.authors = ["Gabe da Silveira"]
  s.date = "2012-04-15"
  s.description = "Define additional sets of validations beyond the standard \"errors\" that is tied to the ActiveRecord life-cycle.  These additional sets can be defined with all the standard ActiveRecord::Validation macros, and the resulting collection is a standard ActiveRecord::Errors object."
  s.email = "gabe@websaviour.com"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    "CHANGELOG",
    "LICENSE",
    "README.md",
    "lib/validation_scopes.rb"
  ]
  s.homepage = "http://github.com/gtd/validation_scopes"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.22"
  s.summary = "Create sets of validations independent of the life-cycle of an ActiveRecord object"

  s.add_dependency 'activerecord'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'sqlite3'
end

