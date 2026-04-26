module PostsHelper
  def render_attachments_preview(post)
    attachments = safe_join([ render_first_attachments_preview(post), render_amount_not_previewed(post) ])
    content_tag(:div, attachments, class: "attachments")

    # <%= link_to(render_attachment_image(attachment, size: [175, 175]), attachment.post, class: "cell image-grid") %>
  end

  def render_category_caption(post)
    content_tag(:span, category_description(post), class: "caption is-size-7 has-text-grey ml-2")
  end

  private

  PREVIEW_SIZE = 5

  def render_first_attachments_preview(post)
    attachments_preview = post.attachments.first(PREVIEW_SIZE).map do |attachment|
      link_to(render_attachment_image(attachment), attachment.post)
    end
    # TODO: handle render of more than PREVIEW_SIZE 5 photos
    safe_join(attachments_preview)
  end

  def render_amount_not_previewed(post)
    content_tag(:span, "#{post.attachments.size - PREVIEW_SIZE} More") if post.attachments.size > PREVIEW_SIZE
  end

  def category_description(post)
    case post.category.to_sym
    when :feed
      "posted"
    when :avatar_selection
      "updated his avatar photo"
    when :background_selection
      "updated his background photo"
    when :interaction
      "> #{post.id}" # TODO: add other user interacted
    when :tagged
      "was tagged by"
    when :repost_own
      "is sharing a past memory"
    when :repost_other
      "is reposted from "
    end
  end
end
