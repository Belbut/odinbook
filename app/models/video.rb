class Video < ApplicationRecord
  has_one_attached :file

  has_one :attachment, as: :annexable
end
