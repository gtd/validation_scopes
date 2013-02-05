# Validation Scopes

This gem adds a simple class method `validation_scope` to ActiveRecord.  This generates a new collection of
`ActiveRecord::Errors` that can be manipulated independently of the standard `errors`, `valid?` and `save` methods.  The
full power of ActiveRecord validations are preserved in these distinct error collections, including all the macros.

For example, in addition to standard errors that prevent an object from being saved to the database, you may want
a second collection of warnings that you display to the user or otherwise shape the control flow:

    class Film < ActiveRecord::Base
      validates_presence_of :title # Standard errors

      validation_scope :warnings do |s|
        s.validate :ensure_title_is_capitalized
        s.validate { |r| r.warnings.add_to_base("Inline warning") }
        s.validates_presence_of…
        s.validates_inclusion_of…
        s.validates_each…
        s.validates_on_create…
      end

      def ensure_title_is_capitalized
        warnings.add(:title, "should be capitalized") unless title =~ %r{\A[A-Z]}
      end
    end

The generated scope produces 3 helper methods based on the symbol passed to the validation_scope method.  Continuing the
previous example:

    film = Film.new(:title => 'lowercase title')
    film.valid?
    => true

    film.no_warnings?   # analagous to valid?
    => false

    film.has_warnings?  # analagous to invalid?
    => true

    film.warnings       # analagous to film.errors
    => #<ActiveRecord::Errors>

    film.warnings.full_messages
    => ["Title should be capitalized", "Inline warning"]

    film.errors.full_messages
    => []

    film.class.all_scopes
    => [:warnings]

    film.save
    => true

One rough edge at the moment is when you want to use the builtin `error_messages_for` helper in your views.  That helper
does not accept an `ActiveRecord::Errors` object directly.  Instead you need to pass it the proxy object that
`ValidationScopes` creates to encapsulate the generated error set:

    error_messages_for :object => film.validation_scope_proxy_for_warnings

## Compatibility

The current version should work for Rails >= 3.0 and Ruby >= 1.9.2.

For Rails 3 and Ruby 1.8.x use version 0.4.x, however **beware there is a memory leak in this version** as described
[here](http://siliconsenthil.in/blog/2013/01/19/validation-scopes-leaks-memory/)

For Rails 2 see the 0.3.x version of the gem which is maintained on the [rails2
branch](https://github.com/gtd/validation_scopes/tree/rails2)

Why no Ruby 1.8.7 support?  Because fixing the memory leak was easy in Ruby 1.9 by removing the deferred proxy class
definition, however this does not work in Ruby 1.8.7 because the ActiveRecord objects methods are not found.  The
development of this was described in a [blog article about the design process](http://darwinweb.net/articles/80).
I didn't take the time to figure out why this started working in Ruby 1.9.x (smells like something to do with
`instance_eval`) but it does, and I have no inclination to fix issues in 1.8.x anymore.  If you happen to know why
offhand though, I'd be glad to hear the reason.


## Installation

The usual:

    gem install validation_scopes

In your Gemfile:

    gem 'validation_scopes'

Or old-school-Rails-style, in your environment.rb:

    config.gem 'validation_scopes'

Outside of Rails:

    require 'validation_scopes'


### Don't use private methods

Because the any validation method supplied as a symbol (eg. `validate :verify_something`) is actually running in the
context of a delegate class, private methods won't work as they would in standard validations.


## TODO

* In Rails 3 validations are no longer coupled to ActiveRecord.  Although the current version of the gem uses
  ActiveModel, it hasn't been tested against arbitrary objects.


## Copyright

Copyright (c) 2010-2013 Gabe da Silveira. See LICENSE for details.
