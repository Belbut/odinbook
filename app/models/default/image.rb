module Default
  class Image < ApplicationRecord
    self.table_name = "default_images"

    validates :kind, inclusion: { in: %w[avatar background] }
    has_one_attached :file
  end
end
