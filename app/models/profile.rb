class Profile < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :name_search, against: :name,
                                ignoring: :accents,
                                using: { trigram: { word_similarity: true } }

  belongs_to :user
  has_one :avatar_photo, -> { where category: :avatar }, as: :imageable, class_name: "Image"
  has_one :background_photo, -> { where category: :background }, as: :imageable, class_name: "Image"

  validates :name, presence: true, allow_blank: false
  normalizes :birthday, with: ->(birthday) { birthday.empty? ? nil : birthday }
  normalizes :location, with: ->(location) { location.empty? ? nil : location }

  def avatar
    avatar_or_default
  end

  def background
    background_or_default
  end

  private

  def avatar_or_default
    record = avatar_photo || ::Default::Image.find_by(kind: "avatar")
    record.file
  end

  def background_or_default
    record = background_photo || ::Default::Image.find_by(kind: "background")
    record.file
  end
end
