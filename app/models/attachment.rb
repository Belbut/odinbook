class Attachment < ApplicationRecord
  belongs_to :post
  belongs_to :annexable, polymorphic: true, dependent: :destroy

  validates_associated :annexable

  def all_errors
    puts "errors was called"
    self.annexable.errors
  end
end
