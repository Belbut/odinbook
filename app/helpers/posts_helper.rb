module PostsHelper
  def render_attachments_preview(post)
    attachments = safe_join([render_first_attachments_preview(post), render_amount_not_previewed(post)])
    content_tag(:div, attachments, class: "attachments")
  end

  private

  PREVIEW_SIZE = 5

  def render_first_attachments_preview(post)
    attachments_preview = post.attachments.first(PREVIEW_SIZE).map do |attachment|
      render_attachment_image(attachment)
    end
    # TODO: handle render of more than PREVIEW_SIZE 5 photos
    safe_join(attachments_preview)
  end

  def render_amount_not_previewed(post)
    content_tag(:span, "#{post.attachments.size - PREVIEW_SIZE} More") if post.attachments.size > PREVIEW_SIZE
  end
end
