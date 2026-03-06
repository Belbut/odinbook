class Content < ApplicationRecord
  delegated_type :contentable, types: %w[Post Comment], dependent: :destroy

  belongs_to :author, class_name: "User", foreign_key: :user_id
  validates :body, length: { maximum: 500 }

  default_scope { where(deleted: false) }
  scope :active, -> {}
  scope :deleted, -> { unscope(deleted: false).where(deleted: true) }
end
