class FriendsController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = User.find(params[:user_id])
    user_friends = @user.friends.includes(profile: [ avatar_photo: [ file_attachment: :blob ] ])
    @friends_profiles = user_friends.map(&:profile)

    if current_user == @user
      pending_incoming_fr_users = @user.pending_incoming_friend_request_users.includes(profile: [ avatar_photo: [ file_attachment: :blob ] ])
      @pending_incoming_fr_profiles = pending_incoming_fr_users.map(&:profile)

      pending_outgoing_fr_users = @user.pending_outgoing_friend_request_users.includes(profile: [ avatar_photo: [ file_attachment: :blob ] ])
      @pending_outgoing_fr_profiles = pending_outgoing_fr_users.map(&:profile)

      recommended_friends = @user.get_recommended_friends(3).includes(profile: [ avatar_photo: [ file_attachment: :blob ] ])
      @recommended_friends_profiles = recommended_friends.map(&:profile)
    end

    target_users = [ user_friends, pending_incoming_fr_users, pending_outgoing_fr_users, recommended_friends ].flatten

    common_friends_precomputed = current_user.mutual_friends_count(target_users,
                                                                   pending_incoming_fr_users,
                                                                   pending_outgoing_fr_users,
                                                                   recommended_friends)

    interactions_precomputed = current_user.users_interactions_status(target_users,
                                                                      pending_incoming_fr_users,
                                                                      pending_outgoing_fr_users,
                                                                      recommended_friends)


    @precompute = { common_friends: common_friends_precomputed, interactions: interactions_precomputed }
  end
end
