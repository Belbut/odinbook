module FriendsHelper
  def render_users_relationships(user_array, common_friends_precomputed = {}, section_heading:)
    return if user_array.empty?

    heading = content_tag(:h2, section_heading)
    profiles = user_array.map do |user|
      render user.profile, common_friends_precomputed: common_friends_precomputed
    end
    content_tag(:section, safe_join([heading, profiles]))
  end
end
