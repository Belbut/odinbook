module AttachmentHelper
  def render_attachment_image(attachment, variant: :medium)
    render_image(attachment.annexable.file, variant: variant)
  end

  # TODO: get a better method name
  def render_avatar_image(user, variant: :medium, optional_class: nil)
    render_image(user.profile.avatar, variant: variant, optional_class: "#{optional_class} avatar_image")
  end

  def render_image(img, variant: :medium, optional_class: nil)
    image_size = Image.image_size[variant]
    url = image_source(img, image_size, variant)
    img = image_tag(url, class: "attachment #{optional_class}", width: image_size[0], height: image_size[1])
    tag.figure(img, class: "ml-0 mr-0")
  end

  private

  def image_source(attachment_file, image_size, variant)
    if attachment_file.blob.service_name == "cloudinary"
      Cloudinary::Utils.cloudinary_url(
        attachment_file.blob.key,
        width: image_size[0], height: image_size[1],
        crop: :fill, fetch_format: :auto, quality: :auto
      )
    else
      attachment_file.variant(variant)
    end
  end
end
