class Attachment < ApplicationRecord
  belongs_to :post
  belongs_to :annexable, polymorphic: true
end
