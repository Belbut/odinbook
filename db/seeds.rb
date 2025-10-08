# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# require Faker
# @message.images.attach(io: File.open("/path/to/file"), filename: "file.pdf")

avatar_img = Default::Image.new(kind: :avatar)
avatar_img.file.attach(io: File.open("app/assets/images/default_user_profile_picture.png"),
                       filename: "default_avatar.png")
avatar_img.save!

test_user = User.new(
  email: "test@test.com",
  password: "123456",
  password_confirmation: "123456",
  profile_attributes: {
    name: "Andre Belbut"
  }
)
test_user.skip_confirmation!
test_user.save!

9.times do
  mass_user = User.new(
    email: Faker::Internet.email,
    password: "123456",
    password_confirmation: "123456",
    profile_attributes: {
      name: Faker::FunnyName.name,
      birthday: Faker::Date.birthday(min_age: 0, max_age: 110),
      # t.string :profile_photo TODO
      # t.string :background_photo TODO
      location: Faker::Address.city
    }
  )
  mass_user.skip_confirmation!
  mass_user.save!
end
