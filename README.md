# README

Data Architecture

User: 
  -email(string)
  -password(string)
  *has_one :Profile
  *has_and_belongs_to_many: Posts AS Liked
  *has_many :Posts
  *has_many :Comments
 


Profile:
  -name(string) 
  -birthday(date)
  -profile photo(binary)
  -background photo(binary)
  -location(string)
  *belong_to :User
  
--------
Post:
  -Body(Text)
  *belongs_to :User As Author
  *has_one :Annex
  *has_and_belongs_to_many :Users As Likes
  *has_many :Comments AS :Commentable

Annex:
  *has_one :Video
  *has_one :Image, AS :imageable
  *belongs_to :Post

Image:
  -File (binary)
  -belongs_to: Imageable Poly:true

Video:
  -File (binary)
  -belongs_to :Annex

Comment:
  -Body(Text)
  *belongs_to :User AS Author
  *belongs_to :Commentable
  *has_many :replies AS :Commentable, class_name :Comment
  

