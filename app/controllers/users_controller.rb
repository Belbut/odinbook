class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
     @users = User.includes(profile: [ avatar_photo: [ file_attachment: :blob ] ])
                  .where.not(id: current_user.id)

      pending_incoming_fr_users = current_user.pending_incoming_friend_request_users
      pending_outgoing_fr_users = current_user.pending_outgoing_friend_request_users

      #  TODO: fix the N+1 inside mutual_friends_count
      common_friends_precomputed = current_user.mutual_friends_count(@users, pending_incoming_fr_users, pending_outgoing_fr_users)
      interactions_precomputed = current_user.users_interactions_status(@users, pending_incoming_fr_users, pending_outgoing_fr_users)

      @precompute = { common_friends: common_friends_precomputed, interactions: interactions_precomputed }
  end
end
