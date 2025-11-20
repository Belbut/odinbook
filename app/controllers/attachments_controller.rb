class AttachmentsController < ApplicationController
  def destroy
    post = current_user.posts.find(params[:post_id])
    attachment = post.attachments.find(params[:id])

    attachment.delete

    redirect_back_or_to post
  end
end
