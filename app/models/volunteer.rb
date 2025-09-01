class Volunteer < ApplicationRecord
  belongs_to :organization
  has_and_belongs_to_many :shifts
  validates :name, presence: true
end
