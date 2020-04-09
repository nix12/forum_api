# frozen_string_literal: true

class Post < ApplicationRecord
  include Friendlyable

  self.primary_key = 'hash_id'

  belongs_to :jet, primary_key: 'slug'
  belongs_to :author, class_name: 'Voter', foreign_key: 'voter_id'
  has_many :comments, -> { order(cached_votes_score: :desc) }, as: :commentable

  serialize :rules, Hash

  scope :fetch_posts_and_links, -> (jet) { (jet.posts + jet.links).sort_by do |post|
    [post.cached_votes_score, post.created_at]
  end.reverse! }

  validates :title, presence: true, length: { minimum: 1, maximum: 100 }
  validates :body, presence: true, length: { minimum: 1, maximum: 40_000 }
  validates :author, presence: true
  validates :jet_id, presence: true

  has_ancestry
  acts_as_votable
  acts_as_paranoid without_default_scope: true
end
