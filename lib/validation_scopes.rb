require 'delegate'
require 'active_record'

module ValidationScopes
  def self.included(base) # :nodoc:
    base.extend ClassMethods
  end

  # Based on AssociatedValidator from ActiveRecord, see:
  # activerecord-4.2.0/lib/active_record/validations/associated.rb @ line 3
  class AssociatedValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      all_valid = Array.wrap(value).all? do |r|
        r.marked_for_destruction? || r.send("no_#{options[:scope]}?")
      end
      unless all_valid
        record.errors.add(attribute, 'is invalid')
      end
    end
  end

  module ClassMethods
    def validation_scopes
      @validation_scopes ||= []
    end

    def validation_proxies
      @validation_proxies ||= {}
    end

    def validation_scope(scope)
      validation_scopes << scope

      base_class = self

      superclass = self.superclass.validation_proxies[scope] || DelegateClass(base_class)
      proxy_class = Class.new(superclass) do
        include ActiveModel::Validations

        @scope = scope
        def self.validates_associated(*attr_names)
          validates_with AssociatedValidator,
            _merge_attributes(attr_names).reverse_merge(scope: @scope)
        end

        # Hacks to support dynamic_model helpers
        def to_model
          self
        end

        class << self; self; end.class_eval do
          # Rails 3 default implementation of model_name blows up for anonymous
          # classes
          define_method(:model_name) do
            base_class.model_name
          end
          # Before Rails 4.1 callback functions were created using the class
          # name, so we must name our anonymous classes.
          define_method(:name) do
            "#{base_class.name}#{scope.to_s.classify}ValidationProxy"
          end
        end
      end

      validation_proxies[scope] = proxy_class

      yield proxy_class

      define_method(scope) do
        send("validation_scope_proxy_for_#{scope}").errors
      end

      define_method("no_#{scope}?") do
        send("validation_scope_proxy_for_#{scope}").valid?
      end

      define_method("has_#{scope}?") do
        send("validation_scope_proxy_for_#{scope}").invalid?
      end

      define_method("init_validation_scope_for_#{scope}") do
        unless instance_variable_defined?("@validation_#{scope}")
          instance_variable_set("@validation_#{scope}", proxy_class.new(self))
        end
      end

      define_method("validation_scope_proxy_for_#{scope}") do
        send "init_validation_scope_for_#{scope}"
        instance_variable_get("@validation_#{scope}")
      end
    end
  end
end

ActiveRecord::Base.send(:include, ValidationScopes)
