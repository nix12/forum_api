# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def destroy
    voter_id = nil
    body = nil if body
    save!(validate: false)
  end
end
