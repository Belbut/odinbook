class Comment < ApplicationRecord
  validates :body, presence: true, length: { maximum: 500 }
  belongs_to :author, class_name: "User", foreign_key: "user_id"

  belongs_to :commentable, polymorphic: true
  alias parent commentable

  has_many :replies, class_name: "Comment", as: :commentable

  def deleted?
    deleted == true
  end
end
