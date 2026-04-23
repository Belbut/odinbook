require "active_support/concern"

module AuthorizesContentAccess
  extend ActiveSupport::Concern

  def authorizes_content_access
    # in case the relationship changes put the user already was involved in the thread
    return true if parent_content.author == current_user

    thread_owned = thread_root_post(parent_content).author
    current_user == thread_owned || current_user.is_friends_with?(thread_owned)
  end

  ALLOWED_PARENT_CLASSES = {
    posts: Post,
   comments: Comment
}.freeze

# represents the content that will become the parent to the new comment that is being created
def parent_content(params = request.params)
  require "pry-byebug"; binding.pry
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
end
