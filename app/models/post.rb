class Post < ApplicationRecord
  validates :body, length: { maximum: 500 }

  belongs_to :author, class_name: "User", foreign_key: "user_id"
  has_many :attachments, dependent: :destroy

  has_many :comments, as: :commentable
  # Alias used only for polymorphic abstractions. use replies comments when post is the only type.
  alias replies comments

  scope :active, -> { where(deleted: false) }
  scope :deleted, -> { where(deleted: true) }

  def attach_files(files_params)
    return if files_params.nil?

    files_params.each do |file|
      img = Image.new(file: file)
      attachments.build(annexable: img)
    end
  end
end
