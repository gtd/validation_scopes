# Validation Scopes

**Note:** *This is the rails2 branch of the plugin.  See ongoing development for rails3 at
https://github.com/dasil003/validation_scopes*

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

    film.save
    => true

One rough edge at the moment is when you want to use the builtin `error_messages_for` helper in your views.  That helper
does not accept an `ActiveRecord::Errors` object directly.  Instead you need to pass it the proxy object that
`ValidationScopes` creates to encapsulate the generated error set:

    error_messages_for :object => film.validation_scope_proxy_for_warnings

## Compatibility

Should work for Ruby 1.8 and 1.9, as well as Rails 2.x and 3.x; Battle-tested in the formers.

## Installation

The usual:

    gem install validation_scopes

In your Gemfile:

    gem 'validation_scopes'

Or old-school Rails-style, in your environment.rb:

    config.gem 'validation_scopes'

Outside of Rails:

    require 'validation_scopes'


## Caveats

Due to the use of a proxy DelegateClass to store each additional set of validations, and some heavy meta-programming to
tie it all together with a clean API, there are likely to be some weird edge cases.  Please let me know if you discover
anything wonky.  I believe the opacity of the solution is worth the convenience it provides in exposing the entirety of
the Validations API.

### Don't use private methods

Because the any validation method supplied as a symbol (eg. `validate :verify_something`) is actually running in the
context of a delegate class, private methods won't work as they would in standard validations.


## Implementation

I had a lot of fun writing this gem even though the result isn't exactly a shining example elegant code.  An [article
about the design process](http://www.darwinweb.net/articles/80) is on my blog.


## TODO

* In Rails 3 validations are no longer coupled to ActiveRecord.  As part of of ActiveModel, validations can be included
  in any object.  It shouldn't be too much work to make validation_scopes work with arbitrary models as well.


## Copyright

Copyright (c) 2010,2011 Gabe da Silveira. See LICENSE for details.
