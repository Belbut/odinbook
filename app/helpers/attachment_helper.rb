module AttachmentHelper
  def render_attachment_image(attachment, variant: :medium)
    return unless attachment.annexable.present? && attachment.annexable.file.representable?

    active_storage_record = attachment.annexable.file.variant(variant)
    image_tag(active_storage_record, class: "attachment")
  end
  # TODO: get a better method name
  def render_avatar_image(user, variant: :medium)
    active_storage_record = user.profile.avatar.variant(variant)
    avatar_image = image_tag(active_storage_record, class: "avatar_image")
    tag.figure(avatar_image, class: "ml-0 mr-2 image")
  end
end
