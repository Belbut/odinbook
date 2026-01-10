module FriendRequestHelper
  BOTH_USERS_SENDED_REQUEST = [true, true].freeze
  ONLY_CURRENT_USER_SENDED_REQUEST = [true, false].freeze
  ONLY_TARGET_USER_SENDED_REQUEST = [false, true].freeze
  NO_USER_SENDED_REQUEST = [false, false].freeze

  def render_user_friend_request_action(current_user, target_user)
    current_user_interacted = FriendRequest.exists?(sender: current_user, receiver: target_user)
    target_user_interacted = FriendRequest.exists?(sender: target_user, receiver: current_user)

    case [current_user_interacted, target_user_interacted]
    when BOTH_USERS_SENDED_REQUEST
      link_to("Unfriend", user_friend_request_path(target_user),
              data: { turbo_method: :delete,
                      turbo_confirm: "Are you sure you want unfriend #{target_user.profile.name}?" })

    when ONLY_CURRENT_USER_SENDED_REQUEST
      link_to("Cancel Friend Request", cancel_user_friend_request_path(target_user), data: { turbo_method: :delete })

    when ONLY_TARGET_USER_SENDED_REQUEST
      accept = link_to("Accept Friend Request", user_friend_request_path(target_user), data: { turbo_method: :post })
      decline = link_to("Decline Friend Request", reject_user_friend_request_path(target_user),
                        data: { turbo_method: :delete,
                                turbo_confirm: "Are you sure you want to decline the invitation?" })

      accept + " / " + decline
    when NO_USER_SENDED_REQUEST
      link_to("Send Friend Request", user_friend_request_path(target_user), data: { turbo_method: :post })
    end
  end
end
