class Task < ApplicationRecord
  validates :title, presence: true

  # Incomplete tasks first, newest first within each group.
  scope :ordered, -> { order(:completed, created_at: :desc) }
end
