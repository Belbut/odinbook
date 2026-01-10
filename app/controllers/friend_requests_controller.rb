class FriendRequestsController < ApplicationController
  before_action :set_users_involved

  def create
    new_friend_request = FriendRequest.new(sender: @initiator, receiver: @target)

    message = if new_friend_request.save
                { notice: "Friend Request Sended" }
              else
                { alert: new_friend_request.errors.full_messages }
              end

    redirect_back_or_to(user_profile_path(@target), **message) # TODO: change the fall back to friendships?
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

    destroyed_records = established_friendship_requests.destroy_all

    message = if destroyed_records.empty?
                { alert: "The were no relationship between the users to erase" }
              else
                { notice: "You ended the friendship" }
              end

    redirect_back_or_to(user_profile_path(@target), **message)
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

    message = if friend_request.nil?
                { notice: "The Friend Request that you referenced didn't exist" }
              elsif friend_request.destroy
                { notice: "Friend Request Destroyed" }
              else
                { alert: friend_request.errors.full_messages }
              end

    redirect_back_or_to(user_profile_path(@target), **message) # TODO: change the fall back to friendships?
  end
end
