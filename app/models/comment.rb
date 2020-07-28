# frozen_string_literal: true

class Comment < ApplicationRecord
  include Friendlyable
  include Postable

  after_find do |_text|
    assign_deleted
  end

  self.primary_key = 'hash_id'

  belongs_to :author, class_name: 'Voter', foreign_key: 'voter_id'
  belongs_to :text, counter_cache: :comments_count, optional: true
  belongs_to :link, counter_cache: :comments_count, optional: true
  belongs_to :commentable, polymorphic: true
  belongs_to :saved_post
  has_many :comments, -> { order(cached_votes_score: :desc) }, as: :commentable

  validates :body, presence: true, length: { minimum: 1, maximum: 10_000 }
  validates :text_id, presence: true unless :link_id
  validates :link_id, presence: true unless :text_id
  validates :commentable_id, presence: true
  validates :commentable_type, presence: true
  validates :parent_id, presence: true, allow_blank: true

  has_ancestry cache_depth: true
  acts_as_list scope: [:ancestry]
  acts_as_votable
end
