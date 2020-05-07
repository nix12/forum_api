class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def destroy
    self.voter_id = nil
    self.body = nil
    self.save!(validate: false)
  end
end
