class Shift < ApplicationRecord
  belongs_to :organization
  has_and_belongs_to_many :volunteers
  validates :starts_at, :ends_at, presence: true
  validate :ends_after_starts

  def ends_after_starts
    if starts_at && ends_at && ends_at <= starts_at
      errors.add(:ends_at, 'must be after starts_at')
    end
  end
end
