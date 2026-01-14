class FriendsController < ApplicationController
  def index
    user = User.find(params[:user_id])

    @user_friends = user.friends

    return unless current_user == user

    @pending_incoming_fr_users = current_user.pending_incoming_friend_request_users
    @pending_outgoing_fr_users = current_user.pending_outgoing_friend_request_users
  end
end
