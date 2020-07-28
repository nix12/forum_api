# frozen_string_literal: true

class SavedPost < ApplicationRecord
  belongs_to :voter
  belongs_to :post, optional: true
  belongs_to :comment, optional: true

  validates :voter, presence: true
  validates :post, presence: true, uniqueness: true
  validates :comment, presence: true, uniqueness: true
end
