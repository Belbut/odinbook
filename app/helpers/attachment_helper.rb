module AttachmentHelper
  def render_attachment_image(attachment, size: [ 300, 300 ])
    return unless attachment.annexable.present? && attachment.annexable.file.representable?

    active_storage_record = attachment.annexable.file.representation(resize_to_fill: size)
    image_tag(active_storage_record, class: "attachment")
  end
  # TODO: get a better method name
end
