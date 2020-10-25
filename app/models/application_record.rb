class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :newest, -> { order(created_at: :desc) }
  scope :oldest, -> { order(created_at: :asc) }
  scope :freshest, -> { order(updated_at: :desc) }
  scope :stalest, -> { order(updated_at: :asc) }
end
