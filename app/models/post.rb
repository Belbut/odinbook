class Post < ApplicationRecord
  validates :body, length: { maximum: 500 }

  belongs_to :author, class_name: "User", foreign_key: "user_id"
  has_many :attachments, dependent: :destroy

  has_many :comments, as: :commentable
  # Alias used only for polymorphic abstractions. use replies comments when post is the only type.
  alias replies comments

  scope :active, -> { unscope(where: :deleted).where(deleted: false) }
  scope :deleted, -> { unscope(where: :deleted).where(deleted: true) }

  default_scope { where(deleted: false) }

  def attach_files(files_params)
    return if files_params.nil?

    files_params.each do |file|
      img = Image.new(file: file)
      attachments.build(annexable: img)
    end
  end
end
