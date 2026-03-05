module LikesHelper
  def render_like_toggle(content)
    if content.likes.include?(current_user)
      button_to "Un-like", content_likes_path(content), method: :delete
    else
      button_to "Like", content_likes_path(content), method: :post
    end
  end

  def content_likes_path(content)
    case content
    when Post
      post_likes_path(content)
    when Comment
      comment_likes_path(content)
    end
  end
end
