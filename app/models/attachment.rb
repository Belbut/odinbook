class Attachment < ApplicationRecord
  belongs_to :post
  belongs_to :annexable, polymorphic: true

  validates_associated :annexable
end
