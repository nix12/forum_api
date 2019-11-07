# frozen_string_literal: true

class Comment < ApplicationRecord
  include Friendlyable

  self.primary_key = 'hash_id'

  belongs_to :author, class_name: 'Voter', foreign_key: 'voter_id'
  belongs_to :post, counter_cache: :comments_count
  belongs_to :commentable, polymorphic: true
  has_many :comments, -> { order(cached_votes_score: :desc) }, as: :commentable

  validates :body, length: { minimum: 1, maximum: 10_000 }
  validates :post_id, presence: true

  has_ancestry cache_depth: true
  acts_as_list scope: [:ancestry]
  acts_as_votable
end
