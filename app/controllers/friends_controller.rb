class FriendsController < ApplicationController
  def index
    @user = User.find(params[:user_id])

    @user_friends = @user.friends

    if current_user == @user
      @pending_incoming_fr_users = @user.pending_incoming_friend_request_users
      @pending_outgoing_fr_users = @user.pending_outgoing_friend_request_users
    end

    @common_friends_memoization = hash_mutual_friends(@user_friends,
                                                      @pending_incoming_fr_users,
                                                      @pending_outgoing_fr_users)
  end

  private

  def hash_mutual_friends(*arrays)
    hash = {}
    current_user_friends = current_user.friends

    arrays.flatten.each do |target_user|
      hash[target_user.id] = current_user_friends.where(id: target_user.friends).size
    end
    hash
  end
end
