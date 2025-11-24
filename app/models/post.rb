class Post < ApplicationRecord
  validates :body, length: { maximum: 500 }

  belongs_to :author, class_name: "User", foreign_key: "user_id"
  has_many :attachments, dependent: :destroy
  has_many :comments, as: :commentable
  
  def attach_files(files_params)
    return if files_params.nil?

    files_params.each do |file|
      img = Image.new(file: file)
      attachments.build(annexable: img)
    end
  end
end
