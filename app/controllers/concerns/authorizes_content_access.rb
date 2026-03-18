require "active_support/concern"

module AuthorizesContentAccess
  extend ActiveSupport::Concern

  included do
    before_action :friends_or_owner_of_thread, only: %i[show create]
  end

  def friends_or_owner_of_thread
    thread_owned = thread_root_post(parent_content).author
    current_user == thread_owned || current_user.is_friends_with?(thread_owned)
  end

  # represents the content that will become the parent to the new comment that is being created
  def parent_content(params = request.params)
    params = params[:comment] if params[:comment]
    return Comment.find(params[:comment_id]) if params[:comment_id]
    return Post.find(params[:post_id]) if params[:post_id]
    return Comment.find(params[:id]) if controller_name == "comments"

    raise "error- parent content is not a post/comment"
  end

  def thread_root_post(content)
    return content if content.is_a?(Post)

    thread_root_post(content.commentable)
  end
end
