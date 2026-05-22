class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable, :trackable, :confirmable
  devise :omniauthable, omniauth_providers: %i[github]

  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile

  has_many :posts
  has_many :comments

  has_and_belongs_to_many :liked_posts, class_name: "Post", foreign_key: "user_id"
  has_and_belongs_to_many :liked_comments, class_name: "Comment", foreign_key: "user_id"

  has_many :friend_requests_received, class_name: "FriendRequest", foreign_key: "receiver_id"
  has_many :friend_requests_sent, class_name: "FriendRequest", foreign_key: "sender_id"

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email || "blank@email.com"
      user.password = Devise.friendly_token[0, 20]
      user.build_profile(name: auth.info.nickname)
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      user.skip_confirmation!
    end
  end

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
    current_user_friends = self.friends

    target_users.flatten.compact.each_with_object({}) do |target_user, hash|
      hash[target_user.id] = current_user_friends.where(id: target_user.friends).size
    end
  end

  def get_recommended_friends(amount)
    recommended_friends_tally = self.tally_second_degree_friends
    ids = recommended_friends_tally.sort_by { |k, v| -v }.map { |user, _| user.id }.first(amount)

    User.where(id: ids)
  end

  def tally_second_degree_friends
    friends_relations = self.friends.map { |f| f.friends }

    result = friends_relations.flatten.tally
    result.delete(self)
    result
  end

  def users_interactions_status(target_users, pending_incoming_fr_users, pending_outgoing_fr_users, recommended_friends = nil)
    current_user_friends = self.friends.to_a

    result = target_users.compact.each_with_object({}) do |target_user, hash|
      hash[target_user.id] = FriendRequest.status_between(self, target_user,
                                                          preprocessed: {
                                                            friends: current_user_friends,
                                                            outgoing_fr_users: pending_outgoing_fr_users,
                                                            incoming_fr_users: pending_incoming_fr_users,
                                                            recommended_friends: recommended_friends
                                                          })
    end
    result
  end

  def is_friends_with?(target_user)
    friends.include?(target_user)
  end

  def make_friendship_with(target)
    fq1 = FriendRequest.new(sender: self, receiver: target)
    fq2 = FriendRequest.new(sender: target, receiver: self)

    fq1.save
    fq2.save
  end

  def cancel_friendship_with(target); end

  private

  def inbound_requests_user_ids
    friend_requests_received.select(:sender_id)
  end

  def outbound_requests_user_ids
    friend_requests_sent.select(:receiver_id)
  end
end
