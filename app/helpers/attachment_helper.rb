module AttachmentHelper
  def render_attachment_image(attachment)
    return unless attachment.annexable.present? && attachment.annexable.file.representable?

    active_storage_record = attachment.annexable.file.representation(resize_to_limit: [300, 300])
    image_tag(active_storage_record)
  end
  # TODO: get a better method name
end
