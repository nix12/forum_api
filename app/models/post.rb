class Post < ApplicationRecord
  include Hashid::Rails

  belongs_to :jet
  has_many :comments, as: :commentable
end
