module FriendsHelper
  def render_relationships_cards_with(profile_array, precompute: {})
    return if profile_array.empty?

    profiles = profile_array.map do |profile|
      card = render profile, precompute: precompute

      tag.div(card, class: "cell")
    end
    safe_join(profiles)
  end
end
