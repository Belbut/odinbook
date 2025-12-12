class AttachmentsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @attachments = Attachment.joins(post: :author).where(users: { id: params[:user_id] }).order(created_at: :desc)
  end

  def destroy
    attachment = Attachment.includes(post: :author).find(params[:id])

    if attachment.post.author != current_user
      redirect_back_or_to post, alert: "You don't have permission to do that"
      return
    end

    attachment.destroy

    redirect_back_or_to attachment.post, notice: "Attachment deleted"
  end
end
