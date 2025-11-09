class Image < ApplicationRecord
  has_one_attached :file

  belongs_to :imageable, polymorphic: true, optional: true
  has_one :attachment, as: :annexable
end
