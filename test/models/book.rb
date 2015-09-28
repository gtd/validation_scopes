class Book < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title

  validation_scope :warnings_book do |s|
    s.validates_presence_of  :author
  end

  validation_scope :alerts_book do |s|
    s.validates_presence_of :isbn
  end

  validation_scope :alerts do |s|
    s.validates_presence_of :isbn
  end
end
