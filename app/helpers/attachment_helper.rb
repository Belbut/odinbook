module AttachmentHelper
  def render_attachment_image(attachment, variant: :medium)
    return unless attachment.annexable.present? && attachment.annexable.file.representable?
    image_size = Image.image_size[variant]


    active_storage_record = attachment.annexable.file.variant(variant)
    img = image_tag(active_storage_record, class: "attachment", width: image_size[0], height: image_size[1])
    tag.figure(img, class: "ml-0 mr-0")
  end
  # TODO: get a better method name
  def render_avatar_image(user, variant: :medium, optional_class: nil)
    image_size = Image.image_size[variant]

    active_storage_record = user.profile.avatar.variant(variant)
    avatar_image = image_tag(active_storage_record, class: "attachment avatar_image #{optional_class}", width: image_size[0], height: image_size[1])
    tag.figure(avatar_image, class: "ml-0 mr-0")
  end
end
