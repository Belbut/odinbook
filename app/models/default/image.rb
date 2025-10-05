module Default
  class Image < ApplicationRecord
    validates :kind, inclusion: { in: %i[avatar background] }
    has_one_attached :file
  end
end


