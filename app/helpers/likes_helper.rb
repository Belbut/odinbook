module LikesHelper
  def like_toggle(content)
    if content.likes.include?(current_user)
      button_to "Un-like", post_likes_path(content), method: :delete
    else
      button_to "Like", post_likes_path(content), method: :post
    end
  end
end
