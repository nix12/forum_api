# frozen_string_literal: true

class Jet < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :posts, primary_key: 'slug', foreign_key: 'jet_id'
  has_many :links, primary_key: 'slug', foreign_key: 'jet_id'
  belongs_to :owner, class_name: 'Voter', foreign_key: 'voter_id'

  validates :name, presence: true, length: { minimum: 3, maximum: 10 },
                   uniqueness: true
end
