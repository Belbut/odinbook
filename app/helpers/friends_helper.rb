module FriendsHelper
  def render_relationships_cards_with(profile_array, common_friends_precomputed: {},
                                      interactions_precomputed: {})
    return if profile_array.empty?

    profiles = profile_array.map do |profile|
      card = render profile, common_friends_precomputed: common_friends_precomputed,
                             interactions_precomputed: interactions_precomputed
      tag.div(card, class: "cell")
    end
    safe_join(profiles)
  end
end
