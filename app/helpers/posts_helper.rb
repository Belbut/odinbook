module PostsHelper

  def not_displayed_attachments(post)
    "#{post.attachments.size - 5} More" if post.attachments.size > 5
  end

  def preview_attachments(post)
    post.attachments.first(5)
  end
end
