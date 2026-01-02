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
  has_many :pending_friends, through: :friend_requests_received, source: :sender

  has_many :friend_requests_sent, class_name: "FriendRequest", foreign_key: "sender_id"
  has_many :requested_friends, through: :friend_requests_sent, source: :receiver

  def friends
    pending = pending_friends.target
    requested = requested_friends.target
    requested.intersection(pending)
  end
end
