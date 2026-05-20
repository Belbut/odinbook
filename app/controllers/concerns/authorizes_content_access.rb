require "active_support/concern"

module AuthorizesContentAccess
  extend ActiveSupport::Concern

  def authorizes_content_access
    return authorizes_page_access if action_name == "index"
    authorizes_thread_access(parent_content)
  end

  def authorizes_page_access
    page_owner = User.find(params[:user_id])

    current_user == page_owner || current_user.is_friends_with?(page_owner)
  end

  # who can see the thread of the content
  # if the comment that we are targeting is authored by the current user
  # we are the original post author or we are friends with the post author
  # else see if any of the thread parent comments are mine
  def authorizes_thread_access(content)
    target_user = content.author
    return true if current_user == target_user
    return authorized_to_see_from?(target_user) if content.is_a?(Post)

    authorizes_thread_access(content.parent)
  end

  ALLOWED_PARENT_CLASSES = {
      posts: Post,
      comments: Comment
    }.freeze

  # represents the content that will become the parent to the new comment that is being created
  def parent_content(params = request.params)
    source = params[:comment] || params
      return Comment.find(source[:comment_id]) if source[:comment_id]
      return Post.find(source[:post_id]) if source[:post_id]

      klass = ALLOWED_PARENT_CLASSES[controller_name.to_sym]
      return klass.find(source[:id]) if klass

      raise "error- parent content is not a post/comment"
  end

  def thread_root_post(content)
    return content if content.is_a?(Post)

    thread_root_post(content.commentable)
  end

  def authorized_to_see_from?(target_user)
    current_user == target_user || current_user.is_friends_with?(target_user)
  end
end
