class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  has_one_attached :file
end

class DefaultImage < ApplicationRecord
  validates :kind, inclusion: { in: %w[avatar background] }
  has_one_attached :file
end
