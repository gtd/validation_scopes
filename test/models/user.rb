class User < ActiveRecord::Base
  belongs_to :sponsor, :class_name => 'User'

  validates_presence_of :name

  validation_scope :warnings do |s|
    s.validates_presence_of  :email
    s.validates_format_of    :email, :with => %r{\A.+@.+\Z}
    s.validates_inclusion_of :age, :in => 0..99
    s.validate do |r|
      if r.sponsor_id.present? && r.sponsor.nil?
        errors.add_to_base("Sponsor ID was defined but record not present")
      end
    end
  end

  # Sadly this must be defined before it use used in a validation_scope.
  def age_under_100
    alerts.add_to_base("We have a centenarian on our hands") if age && age >= 100
  end

  validation_scope :alerts do |s|
    s.validate :age_under_100
    s.validate { |r| errors.add_to_base("We have a super-centenarian on our hands") if r.age && r.age >= 200 }
  end
end