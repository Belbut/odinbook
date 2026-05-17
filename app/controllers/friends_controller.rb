class FriendsController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = User.find(params[:user_id])
    user_friends = @user.friends.includes(:profile)
    @friends_profiles = user_friends.map(&:profile)

    if current_user == @user
      pending_incoming_fr_users = current_user.pending_incoming_friend_request_users.includes(:profile)
      @pending_incoming_fr_profiles = pending_incoming_fr_users.map(&:profile)

      pending_outgoing_fr_users = current_user.pending_outgoing_friend_request_users.includes(:profile)
      @pending_outgoing_fr_profiles = pending_outgoing_fr_users.map(&:profile)

      recommended_friends = current_user.get_recommended_friends(3)
      @recommended_friends_profiles = recommended_friends.map(&:profile)
    end

    common_friends_precomputed = current_user.mutual_friends_count(user_friends,
                                                                   pending_incoming_fr_users,
                                                                   pending_outgoing_fr_users)

    interactions_precomputed = current_user.users_interactions_status(user_friends,
                                                                      pending_incoming_fr_users,
                                                                      pending_outgoing_fr_users)


    @precompute = { common_friends: common_friends_precomputed, interactions: interactions_precomputed }
  end
end
