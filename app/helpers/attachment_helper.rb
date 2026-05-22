module AttachmentHelper
  def render_attachment_image(attachment, variant: :medium)
    return unless attachment.annexable.present? && attachment.annexable.file.representable?
    image_size = Image.image_size[variant]
    url = image_source(attachment.annexable.file, image_size, variant)
    img = image_tag(url, class: "attachment", width: image_size[0], height: image_size[1])
    tag.figure(img, class: "ml-0 mr-0")
  end

  # TODO: get a better method name
  def render_avatar_image(user, variant: :medium, optional_class: nil)
    image_size = Image.image_size[variant]
    url = image_source(user.profile.avatar, image_size, variant)
    avatar_image = image_tag(url, class: "attachment avatar_image #{optional_class}", width: image_size[0], height: image_size[1])
    tag.figure(avatar_image, class: "ml-0 mr-0")
  end

  private

  def image_source(attachment, image_size, variant)
    if attachment.blob.service.is_a?(ActiveStorage::Service::CloudinaryService)
      Cloudinary::Utils.cloudinary_url(
        attachment.blob.key,
        width: image_size[0], height: image_size[1],
        crop: :fill, fetch_format: :auto, quality: :auto
      )
    else
      attachment.variant(variant)
    end
  end
end
