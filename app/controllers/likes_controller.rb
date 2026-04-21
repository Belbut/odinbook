class LikesController < ApplicationController
  def create
    parent_content.likes << current_user
    # TODO: good use case for turbo upgrade
    render partial: "likes/toggle", locals: { content: parent_content }
  end

  def destroy
    parent_content.likes.delete(current_user)
    # TODO: good use case for turbo upgrade
    render partial: "likes/toggle", locals: { content: parent_content }
  end

  def index
    @content = parent_content
    @likes_users = parent_content.likes.includes(:profile)
  end

  private

  def parent_content
    return Post.find(params[:post_id]) if params[:post_id]
    return Comment.find(params[:comment_id]) if params[:comment_id]

    raise "error- parent content is not a post/comment"
  end
end
