class Profile < ApplicationRecord
  belongs_to :user
  has_one :avatar_photo, as: :imageable, class_name: "Image"
  has_one :background_photo, as: :imageable, class_name: "Image"

  validates :name, presence: true

  def avatar_or_default
    record = avatar_photo || ::Default::Image.find_by(kind: "avatar")
    record.file
  end

  def background_or_default
    record = background_photo || ::Default::Image.find_by(kind: "background")
    record.file
  end
end
