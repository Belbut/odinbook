class Post < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  has_many :attachments

  validates :body, length: { maximum: 500 }

  def attach_files(files_params)
    return if files_params.nil?

    files_params.each do |file|
      img = Image.new(file: file)
      attachments.build(annexable: img)
    end
  end
end
