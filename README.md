# Validation Scopes

This gem adds a simple class method `validation_scope` to `ActiveRecord::Base`.  Inside the block you can define validations that don't apply to the life-cycle of the object (ie. they aren't implicitly checked when the object is saved).

    class Film < ActiveRecord::Base
      validation_scope :warnings do |s|
        s.validates_presence_of :title
      end
    end

The generated scope produces 3 helper methods based on the symbol passed to the validation_scope method.  Continuing the previous example:

    film.warnings      # analagous to film.errors
    => #<ActiveRecord::Errors>

    film.no_warnings?  # analagous to film.valid?
    => true

    film.has_warnings?  # analagous to film.invalid?
    => false

All standard `ActiveRecord::Validations` should work.


## Caveats

Due to the use of a proxy DelegateClass to store each additional set of validations, there are some edge cases that don't work perfectly.  The biggest problem is that any methods your validations need must be defined before the validation_scope block.  The reason for this is that the ruby Delegate library determines the methods to be delegated the time the DelegateClass is defined, which happens at the time of the validation_scope is declared.  Therefore:

    class Film < ActiveRecord::Base
      validation_scope :warnings do |s|
        s.validate :ensure_title_is_happy
      end

      def ensure_title_is_happy
        warnings.add_to_base "Title is NOT happy" if unhappy?
      end
    end

Instead the following (smelly) order is necessary:

    class Film < ActiveRecord::Base
      def ensure_title_is_happy
        warnings.add_to_base "Title is NOT happy" if unhappy?
      end

      validation_scope :warnings do |s|
        s.validate :ensure_title_is_happy
      end
    end

I'm trying to find a workaround such as deferring the DelegateClass declaration.  Suggestions/patches are welcome.


## Implementation

The implementation of this gem is meta-programming heavy and very dependent on the internal structure of ActiveRecord as of Rails 2.3.5.  The goal was to be able to utilize the entire functionality of ActiveRecord validations with a minimum of code.  The resulting code is a bit more magic than I would have liked, but it seems to be working for me so far.  I plan on forward porting to Rails 3 and maybe it will be nicer.

The core of the implemention is a dynamically created proxy_class that has ActiveRecord::Validations included in order to isolate its own copy of @errors.  The proxy class is a DelegateClass which gets initialized to the base ActiveRecord object so that validations can use any of the methods of the base object.  Although the use of DelegateClass raises a few issues, it seemed like the cleanest way to do the integration so that all of the ActiveRecord::Validations concerns just work without too much regard to the specifics of the method implementations.


## Copyright

Copyright (c) 2010 Gabe da Silveira. See LICENSE for details.
