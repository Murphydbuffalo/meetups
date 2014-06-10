class Participation < ActiveRecord::Base
  validates :user_id, presence: true
  validates_uniqueness_of :user_id, scope: :meetup_id
  validates :meetup_id, presence: true

  belongs_to :meetup
  belongs_to :user
end