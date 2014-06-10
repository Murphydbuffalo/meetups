class Comment < ActiveRecord::Base
  validates :body, presence: true
  validates :user_id, presence: true
  validates :meetup_id, presence: true

  belongs_to :meetup
  belongs_to :user
end