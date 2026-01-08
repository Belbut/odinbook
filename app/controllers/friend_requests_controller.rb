class FriendRequestsController < ApplicationController
  def create
    sender = current_user
    receiver = User.find(recipient_params)

    friend_request = FriendRequest.new(sender: sender, receiver: receiver)

    require "pry-byebug"
    binding.pry
    if friend_request.save
      flash[:notice] = "Friend Request Sended"
      redirect_back_or_to(user_profile_path(receiver)) # TODO: change the fall back to friendships?
    else
      flash.now[:alert] = friend_request.errors.full_message
    end
  end

  def destroy
    sender = current_user
    receiver = User.find(recipient_params)

    friend_request = FriendRequest.find_by(sender: sender, receiver: receiver)

    if friend_request.destroy
      flash[:notice] = "Friend Request Destroyed"
      redirect_back_or_to(user_profile_path(receiver)) # TODO: change the fall back to friendships?
    else
      flash.now[:alert] = friend_request.errors.full_message
    end
  end

  private

  def recipient_params
    params.expect(:user_id)
  end
end
