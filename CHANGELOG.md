# 0.6.0 - 2015-07-14

* Add support for STI classes (Jeremy Mickelson)
* Add support for validates_associated (Jeremy Mickelson)

# 0.5.2 - 2015-06-18

* Fix Rails 4.2 deprecations and breakages (Tamás Michelberger)
* Loosen version constraints to allow Rails 4 (Ivan Tkalin)

# 0.5.1 - 2013-02-05

* Requires 1.9.2
* Fix for memory leak described at http://siliconsenthil.in/blog/2013/01/19/validation-scopes-leaks-memory/
* Cleaned up .gemspec and removed unnecessary files from distribution
* Set up Gemfile for development
* Simplified test suite to use pure minitest

# 0.4.1 - 2012-04-15

* Rails 3.1 and 3.2 compatibility
* Added the method all_scopes that return all the scopes in a model

# 0.4.0 - 2011-05-23

* Fixed problem with #model_name on proxy class (dynamic_form plugin)
* Fixed problem with scoped errors being lost by error_messages_for (dynamic_form plugin)
* Fixed Rails3 deprecation warnings

# 0.3.1 - 2011-02-24

* Added Rails3 compatibility

# 0.3.0 - 2009-01-04

* Fixed problem with DelegateClass not picking up method definitions that come after the validation_scope block.

# 0.2.0 - 2009-01-04

* Added basic unit tests using in-memory sqlite3

# 0.1.0 - 2009-01-03

* Initial release.  Only tested within an app.  Probably has lots of bugs.  Test suite forthcoming.
