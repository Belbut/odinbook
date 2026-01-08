class FriendRequestController < ApplicationController
  def create
    sender = current_user
    receiver = User.find(recipient_params)

    friend_request = FriendRequest.new(sender: sender, receiver: receiver)
    if friend_request.save
      flash.now[:notice] = "Friend Request Sended"
    else
      flash.now[:alert] = friend_request.errors.full_message
    end
  end

  def destroy; end

  private

  def recipient_params
    params.expect(:user_id)
  end
end
