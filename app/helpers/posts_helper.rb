module PostsHelper
  def render_attachments_preview(post)
    safe_join([render_first_attachments_preview(post), render_amount_not_previewed(post)])
  end

  private

  PREVIEW_SIZE = 5

  def render_first_attachments_preview(post)
    attachments_preview = post.attachments.first(PREVIEW_SIZE).map do |attachment|
      if attachment.annexable.present? && attachment.annexable.file.representable?
        active_storage_record = attachment.annexable.file.representation(resize_to_limit: [300, 300])
        image_tag(active_storage_record)
      end
    end
    # TODO: handle render of more than PREVIEW_SIZE 5 photos
    safe_join(attachments_preview)
  end

  def render_amount_not_previewed(post)
    content_tag(:span, "#{post.attachments.size - PREVIEW_SIZE} More") if post.attachments.size > PREVIEW_SIZE
  end
end
