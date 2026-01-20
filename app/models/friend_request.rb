class FriendRequest < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :sender, uniqueness: { scope: :receiver, message: "That request was already sended" }

  def self.status_between(current_user, target_user,
                          preprocessed_friends: [],
                          preprocessed_outgoing_users: [],
                          preprocessed_incoming_users: [])
    return :BOTH_USERS_SENDED_REQUEST if preprocessed_friends.include?(target_user)
    return :ONLY_CURRENT_USER_SENDED_REQUEST if preprocessed_outgoing_users.include?(target_user)
    return :ONLY_TARGET_USER_SENDED_REQUEST if preprocessed_incoming_users.include?(target_user)

    status(current_user, target_user)
  end

  STATUS_INTERFACE = { [true, true] => :BOTH_USERS_SENDED_REQUEST,
                       [true, false] => :ONLY_CURRENT_USER_SENDED_REQUEST,
                       [false, true] => :ONLY_TARGET_USER_SENDED_REQUEST,
                       [false, false] => :NO_USER_SENDED_REQUEST }.freeze

  def self.status(current_user, target_user)
    current_user_interacted = FriendRequest.exists?(sender: current_user, receiver: target_user)
    target_user_interacted = FriendRequest.exists?(sender: target_user, receiver: current_user)

    STATUS_INTERFACE[[current_user_interacted, target_user_interacted]]
  end
end
