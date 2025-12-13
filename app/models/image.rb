class Image < ApplicationRecord
  has_one_attached :file
  validate :file_must_be_image

  belongs_to :imageable, polymorphic: true, optional: true
  has_one :attachment, as: :annexable

  private

  def file_must_be_image
    return unless file.attached?

    return if file.blob.content_type.in?(%w[image/png image/jpeg image/jpg])

    errors.add(:file, "must be a PNG or JPEG")
  end
end
