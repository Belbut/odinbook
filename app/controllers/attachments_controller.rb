class AttachmentsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @attachments = Attachment.joins(post: :author).where(users: { id: params[:user_id] }).order(created_at: :desc)
  end

  def destroy
    post = current_user.posts.find(params[:post_id])
    attachment = post.attachments.find(params[:id])

    attachment.delete

    redirect_back_or_to post
  end
end
