class Meetup < ActiveRecord::Base
  has_many :comments
  has_many :participations
end