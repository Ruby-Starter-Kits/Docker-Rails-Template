class Post < ApplicationRecord
  validates :title, presence: false
  validates :body, presence: false
end
