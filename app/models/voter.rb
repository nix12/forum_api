# frozen_string_literal: true

class Voter < ApplicationRecord
  before_save { username.downcase! }
  after_initialize :find_upvoted_items, :find_downvoted_items

  self.primary_key = 'username'

  has_many :texts, inverse_of: 'author'
  has_many :links, inverse_of: 'author'
  has_many :comments, inverse_of: 'author'
  has_many :jets, inverse_of: 'owner'

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 10 } if :not_deleted_or_removed

  acts_as_voter

  private
  
  def find_upvoted_items
    self.upvoted_items = find_up_voted_items.compact.map(&:hash_id) || []
  end

  def find_downvoted_items
    self.downvoted_items = find_down_voted_items.compact.map(&:hash_id) || []
  end

  def not_deleted_or_removed
    username != '[deleted]' || 
    username != '[removed]' ||
    username != 'deleted'   ||
    username != 'removed'
  end
end
