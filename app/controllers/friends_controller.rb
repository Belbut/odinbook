class FriendsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @user_friends = @user.friends

    if current_user == @user
      @pending_incoming_fr_users = @user.pending_incoming_friend_request_users
      @pending_outgoing_fr_users = @user.pending_outgoing_friend_request_users
    end

    @common_friends_precomputed = current_user.mutual_friends_count(@user_friends,
                                                                    @pending_incoming_fr_users,
                                                                    @pending_outgoing_fr_users)

    @interactions_precomputed = current_user.users_interactions_status
  end
end
