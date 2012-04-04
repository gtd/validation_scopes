class User < ActiveRecord::Base
  
  belongs_to :sponsor, :class_name => 'User'
  has_many :books

  validates_presence_of :name

  validation_scope :warnings do |s|
    s.validates_presence_of  :email
    s.validates_format_of    :email, :with => %r{\A.+@.+\Z}
    s.validates_inclusion_of :age, :in => 0..99
    s.validate do |r|
      if r.sponsor_id.present? && r.sponsor.nil?
        r.warnings.add(:sponsor_id, "Sponsor ID was defined but record not present")
      end
    end
  end

  validation_scope :alerts do |s|
    s.validate :age_under_100
    s.validate { |r| r.alerts.add(:email, "We have a hotmail user.") if r.email =~ %r{@hotmail\.com\Z} }
  end

  def age_under_100
    alerts.add(:base, "We have a centenarian on our hands") if age && age >= 100
  end
end
