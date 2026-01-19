module FriendsHelper
  def render_users_relationships(user_array, common_friends_memoization = {}, section_heading:)
    return if user_array.empty?

    heading = content_tag(:h2, section_heading)
    profiles = user_array.map do |user|
      render user.profile, common_friends_memoization: common_friends_memoization
    end
    content_tag(:section, safe_join([heading, profiles]))
  end
end
