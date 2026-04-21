module LikesHelper
  def render_like_toggle(content)
    hearth = tag.span(tag.i(class: "fa fa-heart"), class: "icon is_small")

    if content.likes.include?(current_user)
      button_to hearth, content_likes_path(content), method: :delete
    else
      button_to hearth, content_likes_path(content), method: :post

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
