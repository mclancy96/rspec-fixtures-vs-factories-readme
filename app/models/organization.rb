class Organization < ApplicationRecord
	has_many :volunteers, dependent: :destroy
	has_many :shifts, dependent: :destroy
	validates :name, presence: true
end
