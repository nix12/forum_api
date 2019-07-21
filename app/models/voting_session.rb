class VotingSession < ApplicationRecord
  belongs_to :post, optional: true
  belongs_to :comment, optional: true
end
