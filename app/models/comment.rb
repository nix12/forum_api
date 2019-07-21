class Comment < ApplicationRecord
  include Friendlyable
  
  self.primary_key = :hash_id

  belongs_to :post
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable
  has_many :voting_sessions

  validates :body, length: { minimum: 1, maximum: 10000 }
  validates :post_id, presence: true

  acts_as_votable
end
