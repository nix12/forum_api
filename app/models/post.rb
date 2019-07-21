# frozen_string_literal: true

class Post < ApplicationRecord
  include Friendlyable

  self.primary_key = :hash_id

  belongs_to :jet, primary_key: 'slug'
  has_many :comments, as: :commentable
  has_many :voting_sessions

  validates :title, presence: true, length: { minimum: 1, maximum: 100 }
  validates :body, presence: true, length: { minimum: 1, maximum: 40_000 }
  validates :jet_id, presence: true

  acts_as_votable
end
