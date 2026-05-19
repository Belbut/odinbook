class Image < ApplicationRecord
  has_one_attached :file do |f|
    f.variant :medium, resize_to_fill: [ 300, 300 ], preprocessed: true
    f.variant :rectangular, resize_to_fill: [ 600, 300 ], preprocessed: true
    f.variant :avatar, resize_to_fill: [ 48, 48 ], preprocessed: true
  end

  validate :file_must_be_image

  belongs_to :imageable, polymorphic: true, optional: true
  has_one :attachment, as: :annexable

  enum :category, { avatar: "avatar", background: "background", feed: "feed" }

  private

  def file_must_be_image
    return unless file.attached?

    return if file.blob.content_type.in?(%w[image/png image/jpeg image/jpg image/avif])

    errors.add(:file, "must be a image format (png/jpeg/jpg/avif)")
  end
end
