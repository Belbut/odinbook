class FriendRequestsController < ApplicationController
  before_action :set_users_involved

  def create
    new_friend_request = FriendRequest.new(sender: @initiator, receiver: @target)

    if new_friend_request.save
      flash[:notice] = "Friend Request Sended"
    else
      flash[:alert] = new_friend_request.errors.full_messages
    end
    redirect_back_or_to(user_profile_path(@target)) # TODO: change the fall back to friendships?
  end

  def cancel
    destroy_friend_request(sender: @initiator, receiver: @target)
  end

  def reject
    destroy_friend_request(sender: @target, receiver: @initiator)
  end

  def destroy
    established_friendship_requests = FriendRequest.where(sender: [@initiator, @target],
                                                          receiver: [@target, @initiator])

    if established_friendship_requests.nil?
      return redirect_back_or_to(user_profile_path(@target),
                                 notice: "There was no Friend Request to destroy")
    end

    if established_friendship_requests.destroy_all
      flash[:notice] = "You ended the friendship"
    else
      flash[:alert] = established_friendship_requests.errors.full_messages
    end
    redirect_back_or_to(user_profile_path(@target)) # TODO: change the fall back to friendships?
  end

  private

  def target_params
    params.expect(:user_id)
  end

  def set_users_involved
    @initiator = current_user
    @target = User.find(target_params)
  end

  def destroy_friend_request(sender:, receiver:)
    friend_request = FriendRequest.find_by(sender: sender, receiver: receiver)

    if friend_request.nil?
      return redirect_back_or_to(user_profile_path(@target),
                                 notice: "There was no Friend Request to destroy")
    end

    if friend_request.destroy
      flash[:notice] = "Friend Request Destroyed"
    else
      flash[:alert] = friend_request.errors.full_messages
    end
    redirect_back_or_to(user_profile_path(@target)) # TODO: change the fall back to friendships?
  end
end
