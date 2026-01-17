class FriendsController < ApplicationController
  def index
    @user = User.includes(:profile, :friend_requests_received, :friend_requests_sent).find(params[:user_id])

    @user_friends = @user.friends

    return unless current_user == @user

    @pending_incoming_fr_users = current_user.pending_incoming_friend_request_users.includes(:profile,
                                                                                             :friend_requests_received,
                                                                                             :friend_requests_sent)

    @pending_outgoing_fr_users = current_user.pending_outgoing_friend_request_users.includes(:profile,
                                                                                             :friend_requests_received,
                                                                                             :friend_requests_sent)
  end
end
