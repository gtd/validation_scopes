class AssociatedScopeValidator < ActiveRecord::Validations::AssociatedValidator
  attr_accessor :scope

  def initialize(options = {})
    super(options)
    @scope = options[:with]
  end

  def validate_each(record, attribute, value)
    any_invalid = Array.wrap(value).reject do |r|
      r.marked_for_destruction? || r.send("no_#{scope}?")
    end.any?

    if any_invalid
      record.send(scope).add(attribute, :invalid, options.merge(value: value))
    end
  end
end
