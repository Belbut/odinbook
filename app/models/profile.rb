class Profile < ApplicationRecord
  belongs_to :user
  has_one :avatar_photo, as: :imageable
  has_one :background_photo, as: :imageable

  validates :name, presence: true
end
