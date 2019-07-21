# frozen_string_literal: true

class Jet < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  self.primary_key = :slug

  has_many :posts, primary_key: 'slug'

  validates :name, presence: true, length: { minimum: 3, maximum: 10 }
end
