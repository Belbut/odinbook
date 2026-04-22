class Post < ApplicationRecord
  enum :category, {
    feed: "feed",
    avatar_selection: "avatar_selection", background_selection: "background_selection",
    tagged: "tagged", interaction: "interaction",
    repost_own: "repost_own", repost_other: "repost_other"
  }, prefix: true # TODO: cover rest of the options.

  after_commit :update_profile, on: :create

  validates :body, length: { maximum: 500 }

  belongs_to :author, class_name: "User", foreign_key: "user_id"

  has_many :attachments, dependent: :destroy
  validate :attachments_cardinality_by_category

  has_many :comments, as: :commentable
  # Alias used only for polymorphic abstractions. use replies comments when post is the only type.
  alias replies comments

  has_and_belongs_to_many :likes, class_name: "User", foreign_key: "post_id"

  scope :active, -> { where(deleted: false) }
  scope :deleted, -> { where(deleted: true) }

  def attach_files(files_params, post_category = nil)
    return if files_params.nil?

    files_params.each do |file|
      img = Image.new(file: file, category: image_category(post_category))
      attachments.build(annexable: img)
    end
  end

  def all_errors
    require "pry-byebug"; binding.pry
    if self.errors[:attachments].empty?
      self.errors.full_messages
    else
      self.attachments.flat_map { |attachment| attachment.all_errors.full_messages }
    else
      self.errors.full_messages
    end
  end

  private

  def attachments_cardinality_by_category
    return unless %w[avatar_selection background_selection].include?(category)
    return if attachments.size == 1

    errors.add(:content, "For the post #{category} there needs to be one and only one attachment")
  end

  def image_category(post_category)
    case post_category.to_sym
    when :avatar_selection then :avatar
    when :background_selection then :background
    end
  end

  def avatar_image
    attachments.find { |a| a.annexable.avatar? }.annexable
  end

  def background_image
    attachments.find { |a| a.annexable.background? }.annexable
  end

  def update_profile
    case category.to_sym
    when :avatar_selection
      author.profile.avatar_photo = avatar_image
    when :background_selection
      author.profile.background_photo = background_image
    end
  end
end
