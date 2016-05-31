require 'delegate'
require 'active_record'
require 'associated_scope_validator'

module ValidationScopes
  def self.included(base) # :nodoc:
    base.extend ClassMethods
  end

  module ClassMethods
    def validation_scope(scope)
      @all_scopes ||= []
      @all_scopes << scope

      def self.all_scopes
        @all_scopes
      end

      base_class = self

      proxy_class = Class.new(DelegateClass(base_class)) do
        if defined?(ActiveRecord) && base_class.superclass == ActiveRecord::Base
          include ActiveRecord::Reflection
          include ActiveRecord::Validations
        end

        include ActiveModel::Validations

        def initialize(record)
          @base_record = record
          super(record)
        end

        # Hacks to support dynamic_model helpers
        def to_model
          self
        end

        # Rails 3 default implementation of model_name blows up for anonymous classes
        class << self; self; end.class_eval do
          define_method(:model_name) do
            base_class.model_name
          end
        end
      end

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
        unless instance_variable_defined?("@#{scope}")
          instance_variable_set("@#{scope}", proxy_class.new(self))
        end
      end

      define_method("validation_scope_proxy_for_#{scope}") do
        send "init_validation_scope_for_#{scope}"
        instance_variable_get("@#{scope}")
      end
    end
  end
end

ActiveRecord::Base.send(:include, ValidationScopes)
