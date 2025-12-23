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

  has_many :relationships_out, foreign_key: "sender_id", class_name: "Relationship"
  has_many :friendships_invitations, through: :relationships_out, source: :sender

  has_many :relationships_in, foreign_key: "receiver_id", class_name: "Relationship"
  has_many :friendships_requests, through: :relationships_in, source: :receiver
end
