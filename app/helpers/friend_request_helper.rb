module FriendRequestHelper
  def render_user_friend_request_action(current_user, target_user) # TODO: refactor the friendsRequest logic so that it doesnt make new queries
    friend_request_status = FriendRequest.status_between(current_user, target_user)

    case friend_request_status
    when :BOTH_USERS_SENDED_REQUEST
      link_to("Unfriend", user_friend_request_path(target_user),
              data: { turbo_method: :delete,
                      turbo_confirm: "Are you sure you want unfriend #{target_user.profile.name}?" })

    when :ONLY_CURRENT_USER_SENDED_REQUEST
      link_to("Cancel Friend Request", cancel_user_friend_request_path(target_user), data: { turbo_method: :delete })

    when :ONLY_TARGET_USER_SENDED_REQUEST
      accept = link_to("Accept Friend Request", user_friend_request_path(target_user), data: { turbo_method: :post })
      decline = link_to("Decline Friend Request", reject_user_friend_request_path(target_user),
                        data: { turbo_method: :delete,
                                turbo_confirm: "Are you sure you want to decline the invitation?" })

      safe_join([accept, tag.span("/"), decline])
    when :NO_USER_SENDED_REQUEST
      link_to("Send Friend Request", user_friend_request_path(target_user), data: { turbo_method: :post })
    end
  end
end
