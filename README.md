# README
Testing
  gems:
    -**byebug**
    -**rspec-rails**
    -factory bot vs **fixtures**
    -capybara?
    -database-cleaner?

Data Architecture

  User: 
    -email(string)
    -password(string)
    *has_one: Profile
    *has_and_belongs_to_many: Users AS Friends
    *has_and_belongs_to_many: Posts AS Likes
    *has_many: Posts
    *has_many :Comments
  


  Profile:
    -name(string) 
    -birthday(date)
    -location(string)
    *belong_to: User
    *has_one: avatar_picture As Imageable class_name:Image
    *has_one: Background_picture As Imageable class_name:Image
    
  --------
  Post:
    -Body(Text)
    *belongs_to: User As Author
    *has_one: Annex
    *has_and_belongs_to_many :Users As Likes
    *has_many :Comments AS :Commentable

  Annex:
    *belongs_to: Post
    *belongs to Attachable Poly:true

  Image:
    -File (string)
    *belongs_to: Imageable Poly:true
    *Has_one :Annex AS Attachable
    *has_one_attached :file


  Video:
    -File (string)
    *Has_one :Annex AS Attachable

  Comment:
    -Body(Text)
    *belongs_to :User AS Author
    *belongs_to :Commentable
    *has_many :replies AS :Commentable, class_name :Comment


This app uses Active Storage with `libvips` for image processing.

Install `libvips` before running the server:

- macOS: `brew install vips`
- Ubuntu/Debian: `sudo apt install libvips libvips-dev`