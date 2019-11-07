# frozen_string_literal: true

class Voter < ApplicationRecord
  after_initialize :find_upvoted_items, :find_downvoted_items

  self.primary_key = 'username'

  has_many :posts, inverse_of: 'author'
  has_many :comments, inverse_of: 'author'
  has_many :jets, inverse_of: 'owner'

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 10 }

  acts_as_voter

  private

  def find_upvoted_items
    self.upvoted_items = find_up_voted_items.map(&:hash_id) || []
  end

  def find_downvoted_items
    self.downvoted_items = find_down_voted_items.map(&:hash_id) || []
  end
end
