class LikesController < ApplicationController
  def create
    current_user.liked_posts << parent_content
    redirect_back_or_to parent_content
    # TODO: good use case for turbo upgrade
  end

  def destroy
    current_user.liked_posts.delete(parent_content)
    redirect_back_or_to parent_content
    # TODO: good use case for turbo upgrade
  end

  private

  def parent_content
    return Post.find(params[:post_id]) if params[:post_id]
    return Comments.find(params[:comment_id]) if params[:comment_id]

    raise "error- parent content is not a post/comment"
  end
end
