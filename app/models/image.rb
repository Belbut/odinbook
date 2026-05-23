class Image < ApplicationRecord
  MEDIUM = [ 300, 300 ]
  RECTANGULAR = [ 600, 300 ]
  AVATAR = [ 72, 72 ]
  BACKGROUND = [ 1250, 450 ]
  PROFILE = [ 200, 200 ]

  def self.image_size
     { avatar: AVATAR,
       rectangular: RECTANGULAR,
       medium: MEDIUM,
       background: BACKGROUND,
       profile: PROFILE
     }
  end

  has_one_attached :file do |f|
    f.variant :medium, resize_to_fill: MEDIUM# , preprocessed: true
    f.variant :rectangular, resize_to_fill: RECTANGULAR# , preprocessed: true
    f.variant :avatar, resize_to_fill: AVATAR# , preprocessed: true
    f.variant :background, resize_to_fill: BACKGROUND
    f.variant :profile, resize_to_fill: PROFILE
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
