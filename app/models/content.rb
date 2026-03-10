class Content < ApplicationRecord
  delegated_type :contentable, types: %w[Post Comment], dependent: :destroy
  accepts_nested_attributes_for :contentable

  belongs_to :author, class_name: "User", foreign_key: :user_id
  validates :body, length: { maximum: 500 }

  default_scope { where(deleted: false) }
  scope :active, -> {}
  scope :deleted, -> { unscope(deleted: false).where(deleted: true) }

  def self.new_with_post(author:, category: nil, **attrs)
    new(contentable: Post.new(category: category), author: author, **attrs)

    green_refactor = new(contentable: Post.new(category: category, author: author), author: author, **attrs)
  end
end
