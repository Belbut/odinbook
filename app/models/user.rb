class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :confirmable, :trackable
  devise :omniauthable, omniauth_providers: %i[github]

  has_one :profile, required: true
  accepts_nested_attributes_for :profile

  has_many :posts
  has_many :comments

  has_many :friend_requests_received, class_name: "FriendRequest", foreign_key: "receiver_id"
  has_many :friend_requests_sent, class_name: "FriendRequest", foreign_key: "sender_id"

  def friends
    User.where(id: inbound_requests_user_ids).where(id: outbound_requests_user_ids)
  end

  def pending_incoming_friend_request_users
    User.where(id: inbound_requests_user_ids).where.not(id: outbound_requests_user_ids)
  end

  def pending_outgoing_friend_request_users
    User.where(id: outbound_requests_user_ids).where.not(id: inbound_requests_user_ids)
  end

  def common_friends_with(target_user)
    User.where(id: friends).where(id: target_user.friends)
  end

  def mutual_friends_count(*target_users)
    hash = {}
    current_user_friends = friends

    target_users.flatten.each do |target_user|
      hash[target_user.id] = current_user_friends.where(id: target_user.friends).size
    end
    hash
  end

  def users_interactions_status(*target_users)
    hash = {}
    current_user_friends = friends
    pending_incoming_fr_users = pending_incoming_friend_request_users
    pending_outgoing_fr_users = pending_outgoing_friend_request_users

    target_users.flatten.each do |target_user|
      hash[target_user.id] = FriendRequest.status_between(self, target_user,
                                                          preprocessed_friends: current_user_friends,
                                                          preprocessed_outgoing_users: pending_outgoing_fr_users,
                                                          preprocessed_incoming_users: pending_incoming_fr_users)
    end
    hash
  end

  private

  def inbound_requests_user_ids
    friend_requests_received.select(:sender_id)
  end

  def outbound_requests_user_ids
    friend_requests_sent.select(:receiver_id)
  end
end
