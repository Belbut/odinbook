# db/seeds.rb — Odinbook: Animal Social Network
# 10 animal accounts, rich posts, images, friendships, and interactions.

# ============================================================
# RESET
# ============================================================
puts "Resetting database..."
ActiveRecord::Base.connection.execute(
  "TRUNCATE TABLE comments_users, posts_users, comments, attachments, posts, " \
  "friend_requests, images, profiles, users, default_images, " \
  "active_storage_attachments, active_storage_blobs, active_storage_variant_records " \
  "RESTART IDENTITY CASCADE"
)

# ============================================================
# DEFAULT IMAGES
# ============================================================
puts "Creating default images..."
def_avatar = Default::Image.create!(kind: :avatar)
def_avatar.file.attach(
  io: File.open("app/assets/images/default_user_profile_picture.png"),
  filename: "default_avatar.png",
  content_type: "image/png"
)

def_bg = Default::Image.create!(kind: :background)
def_bg.file.attach(
  io: File.open("app/assets/images/default_user_background_picture.jpg"),
  filename: "default_background.jpg",
  content_type: "image/jpeg"
)

# ============================================================
# HELPERS
# ============================================================

SEED_BASE = "db/seeds"

def sp(animal, filename)
  "#{SEED_BASE}/#{animal}/#{filename}"
end

def make_user(email:, name:, location:, birthday:)
  u = User.new(
    email: email,
    password: "password123",
    password_confirmation: "password123",
    profile_attributes: { name: name, location: location, birthday: birthday }
  )
  u.skip_confirmation!
  u.save!
  u
end

def avatar_post(user, path)
  post = Post.new(author: user, body: "", category: "avatar_selection")
  img  = Image.new(category: "avatar")
  img.file.attach(io: File.open(path), filename: File.basename(path), content_type: "image/jpeg")
  post.attachments.build(annexable: img)
  post.save!
end

def bg_post(user, path)
  post = Post.new(author: user, body: "", category: "background_selection")
  img  = Image.new(category: "background")
  img.file.attach(io: File.open(path), filename: File.basename(path), content_type: "image/jpeg")
  post.attachments.build(annexable: img)
  post.save!
end

def feed_post(user, body, *paths)
  post = Post.new(author: user, body: body, category: "feed")
  paths.each do |path|
    img = Image.new(category: "feed")
    img.file.attach(io: File.open(path), filename: File.basename(path), content_type: "image/jpeg")
    post.attachments.build(annexable: img)
  end
  post.save!
  post
end

def befriend(u1, u2)
  FriendRequest.create!(sender: u1, receiver: u2)
  FriendRequest.create!(sender: u2, receiver: u1)
end

def send_request(from:, to:)
  FriendRequest.create!(sender: from, receiver: to)
end

def comment_on(author:, post:, body:)
  Comment.create!(author: author, commentable: post, body: body)
end

def reply_to(author:, comment:, body:)
  Comment.create!(author: author, commentable: comment, body: body)
end

# ============================================================
# BIRD — Chirpy Featherstone
# ============================================================
puts "Creating Bird..."
bird = make_user(
  email:    "chirpy@odinbook.com",
  name:     "Chirpy Featherstone",
  location: "Treetop Heights",
  birthday: Date.new(1995, 3, 21)
)
avatar_post(bird, sp("Bird", "aarn-giri-3lGi0BXJ1W0-unsplash.jpg"))
bg_post(bird,     sp("Bird", "bruce-jastrow-l1H0sF8-v0k-unsplash.jpg"))

bp = []
bp << feed_post(bird,
  "The world looks different from up here. Every morning I watch the sun rise over the treetops and find peace in how small everything looks from above.",
  sp("Bird", "david-clode-7_TTPznVIQI-unsplash.jpg"),
  sp("Bird", "deepak-nautiyal-Nbv7PkL_rvI-unsplash.jpg"))
bp << feed_post(bird,
  "Found an incredible perch today. You can see the entire valley from here — the river, the meadows, even a sliver of ocean on a clear day.",
  sp("Bird", "dulcey-lima-P7fVUSY-5ws-unsplash.jpg"),
  sp("Bird", "jacques-le-henaff-ic-13C3QhAI-unsplash.jpg"))
bp << feed_post(bird,
  "Teaching the fledglings their first flight today. There is no greater joy than watching someone discover their wings.",
  sp("Bird", "jan-meeus-7LsuYqkvIUM-unsplash.jpg"))
bp << feed_post(bird,
  "Migration season begins soon. Already charting the route south, following the wind currents I have known since birth.",
  sp("Bird", "timothy-dykes-_aNtQKnffAA-unsplash.jpg"))
bp << feed_post(bird,
  "Singing in the rain because life is too short to wait for sunny days.",
  sp("Bird", "vincent-van-zalinge-vUNQaTtZeOo-unsplash.jpg"))

# ============================================================
# COW — Mocha Fields
# ============================================================
puts "Creating Cow..."
cow = make_user(
  email:    "mocha@odinbook.com",
  name:     "Mocha Fields",
  location: "Cloverdale Meadows",
  birthday: Date.new(1990, 6, 15)
)
avatar_post(cow, sp("Cow", "anand-thakur-y0dSeflqUWo-unsplash.jpg"))
bg_post(cow,     sp("Cow", "claudio-schwarz-uR5w1Y9-8yE-unsplash.jpg"))

cp = []
cp << feed_post(cow,
  "There is a peace in morning grass that no alarm clock can disturb. Just the dew, the clover, and the slow rhythm of the day ahead.",
  sp("Cow", "daniel-j-schwarz-GHaP0MGSRLA-unsplash.jpg"),
  sp("Cow", "diana-shchurova-tDRZNFrz9yA-unsplash.jpg"))
cp << feed_post(cow,
  "The meadow looks particularly golden this afternoon. These are the moments worth pausing for.",
  sp("Cow", "iga-palacz-qZPEd8LO1Sg-unsplash.jpg"),
  sp("Cow", "kylee-alons-suQ-D-9dmVU-unsplash.jpg"))
cp << feed_post(cow,
  "Found a perfect patch of clover near the old oak. Sometimes the simple things really are the best things.",
  sp("Cow", "laura-adai-LdZQaNADsX8-unsplash.jpg"))
cp << feed_post(cow,
  "Watched the sunset from the north pasture tonight. The colors were something else entirely.",
  sp("Cow", "michael-oeser-K8bXGdNiE5w-unsplash.jpg"))
cp << feed_post(cow,
  "Slow mornings, soft grass, and good company. What more could anyone ask for.",
  sp("Cow", "stijn-te-strake-UdhpcfImQ9Y-unsplash.jpg"),
  sp("Cow", "wolfgang-hasselmann-CY6MLcLvdX0-unsplash.jpg"))

# ============================================================
# DEER — Breezy Forrest
# ============================================================
puts "Creating Deer..."
deer = make_user(
  email:    "breezy@odinbook.com",
  name:     "Breezy Forrest",
  location: "Whispering Pines",
  birthday: Date.new(1998, 10, 4)
)
avatar_post(deer, sp("Deer", "andrea-chioldin-6LChsc9M2rA-unsplash.jpg"))
bg_post(deer,     sp("Deer", "andreas-rasmussen-Iw12lY3koDk-unsplash.jpg"))

dp = []
dp << feed_post(deer,
  "The forest at dawn has a magic that is hard to put into words. Every footstep on fallen leaves sounds like a secret being told.",
  sp("Deer", "diana-parkhouse-WP1O_-J87KU-unsplash.jpg"),
  sp("Deer", "laura-college-K_Na5gCmh38-unsplash.jpg"))
dp << feed_post(deer,
  "Spotted a fawn in the clearing today. The next generation always fills me with hope.",
  sp("Deer", "oleksii-demydenko-UlAYsmjgauc-unsplash.jpg"),
  sp("Deer", "philipp-pilz-iQRKBNKyRpo-unsplash.jpg"))
dp << feed_post(deer,
  "Autumn is coming and the forest knows it first. The air has changed, the light has softened, the leaves are beginning their transformation.",
  sp("Deer", "tim-schmidbauer-AjX1v-oXP-4-unsplash.jpg"))
dp << feed_post(deer,
  "Running through open fields at dusk is my favorite thing in the world. The wind, the fading light, the pure freedom of it.",
  sp("Deer", "yuya-yoshioka-0U1TsyC7RZE-unsplash.jpg"))
dp << feed_post(deer,
  "Resting by the stream. Sometimes stillness is the loudest thing in the forest.")

# ============================================================
# DOG — Barkley Chase
# ============================================================
puts "Creating Dog..."
dog = make_user(
  email:    "barkley@odinbook.com",
  name:     "Barkley Chase",
  location: "Sunnyvale Park",
  birthday: Date.new(2003, 1, 28)
)
avatar_post(dog, sp("Dog", "andrea-lightfoot-qhG3uQKaK9c-unsplash.jpg"))
bg_post(dog,     sp("Dog", "baptist-standaert-mx0DEnfYxic-unsplash.jpg"))

dop = []
dop << feed_post(dog,
  "Best walk ever. Twelve new smells, three squirrels, and a puddle I was not supposed to go in. No regrets.",
  sp("Dog", "barbara-mcdermott-ecZsO6GEwNE-unsplash.jpg"),
  sp("Dog", "brayden-prato-MJ9gSUqshcc-unsplash.jpg"))
dop << feed_post(dog,
  "Fetch is not just a game. It is a philosophy. You throw it, I bring it back. Loyalty and joy, every single time.",
  sp("Dog", "pauline-loroy-U3aF7hgUSrk-unsplash.jpg"))
dop << feed_post(dog,
  "Waiting by the door again. Not because anyone is coming. Just because waiting is its own kind of hope.",
  sp("Dog", "pauline-loroy-XH8A0bvQ7iE-unsplash.jpg"))
dop << feed_post(dog,
  "Rain day means couch day. And couch day is the best day after walk day.",
  sp("Dog", "pedro-sanz-hjcZmky9TsQ-unsplash.jpg"))
dop << feed_post(dog,
  "There is nothing in the world like the moment someone comes home.",
  sp("Dog", "ramiro-pianarosa-cHHVhLMo79g-unsplash.jpg"),
  sp("Dog", "tereza-ruba-4uEG5mngAU4-unsplash.jpg"))

# ============================================================
# ELEPHANT — Ellie Trunkwood
# ============================================================
puts "Creating Elephant..."
elephant = make_user(
  email:    "ellie@odinbook.com",
  name:     "Ellie Trunkwood",
  location: "Savanna Basin",
  birthday: Date.new(1957, 8, 12)
)
avatar_post(elephant, sp("Elephant", "aj-robsin-BuQ1RZckYW4-unsplash.jpg"))
bg_post(elephant,     sp("Elephant", "eric-heininger-1P9_gs54iZw-unsplash.jpg"))

ep = []
ep << feed_post(elephant,
  "We walked thirty miles today following the same ancient path our grandmothers walked. The land remembers us even when we are gone.",
  sp("Elephant", "felix-m-dorn-nizP9Lwl2rM-unsplash.jpg"),
  sp("Elephant", "geranimo-AX9sJ-mPoL4-unsplash.jpg"))
ep << feed_post(elephant,
  "The watering hole brought old friends together this afternoon. Some bonds do not need words or years to maintain their strength.",
  sp("Elephant", "geranimo-f0oe9P9Yixs-unsplash.jpg"),
  sp("Elephant", "glen-carrie-EvuwEKi1b1A-unsplash.jpg"))
ep << feed_post(elephant,
  "A hundred years of memory in this place. The trees have grown, the rivers have shifted, but the family stays together.",
  sp("Elephant", "glen-carrie-fiFEpA11tvs-unsplash.jpg"),
  sp("Elephant", "glen-carrie-XLlshtfXWgE-unsplash.jpg"))
ep << feed_post(elephant,
  "Watching the little ones splash and play. This is what we protect. This is what we carry forward.",
  sp("Elephant", "patrick-baum-evDuzZd8Kc0-unsplash.jpg"))
ep << feed_post(elephant,
  "Dust and distance and the wide open sky. There is freedom in migration and meaning in the journey home.",
  sp("Elephant", "richard-jacobs-8oenpCXktqQ-unsplash.jpg"))

# ============================================================
# FOX — Rusty Nightshade
# ============================================================
puts "Creating Fox..."
fox = make_user(
  email:    "rusty@odinbook.com",
  name:     "Rusty Nightshade",
  location: "Ember Ridge",
  birthday: Date.new(2001, 11, 30)
)
avatar_post(fox, sp("Fox", "daniil-silantev-vdlKQXBwOWY-unsplash.jpg"))
bg_post(fox,     sp("Fox", "dusan-veverkolog-nOsJYzXEG98-unsplash.jpg"))

fxp = []
fxp << feed_post(fox,
  "They call the hour before dawn the blue hour. That is my hour. The world is half asleep and wholly mine.",
  sp("Fox", "federico-di-dio-photography-Wstln0400pE-unsplash.jpg"),
  sp("Fox", "jeremy-hynes-mwIqqM1otnk-unsplash.jpg"))
fxp << feed_post(fox,
  "Caught the most extraordinary scent on the eastern ridge this morning. The forest is full of secrets if you know how to listen.",
  sp("Fox", "karen-m9oQ1C_--EE-unsplash.jpg"))
fxp << feed_post(fox,
  "Dusk is a kind of magic. Everything softens and the sharp edges of the day begin to blur.",
  sp("Fox", "olga-kononenko-FdSD_9r8Uy8-unsplash.jpg"))
fxp << feed_post(fox,
  "Left three dead ends and found one perfect path. That is a good day by any measure.",
  sp("Fox", "ray-hennessy-xUUZcpQlqpM-unsplash.jpg"))
fxp << feed_post(fox,
  "The night has a vocabulary the day cannot speak. You just have to learn the language.")

# ============================================================
# JELLYFISH — Crystal Glowsworth
# ============================================================
puts "Creating Jellyfish..."
jellyfish = make_user(
  email:    "crystal@odinbook.com",
  name:     "Crystal Glowsworth",
  location: "Midnight Trench",
  birthday: Date.new(2005, 7, 4)
)
avatar_post(jellyfish, sp("Jellyfish", "ben-bracken-juTL6roVYQQ-unsplash.jpg"))
bg_post(jellyfish,     sp("Jellyfish", "connor-carruthers-2XlRNChm2rg-unsplash.jpg"))

jp = []
jp << feed_post(jellyfish,
  "Drifting through the thermocline today where cold water meets warm. The bioluminescence down here is unlike anything above the surface.",
  sp("Jellyfish", "florian-olivo-GVe30cQ8CWU-unsplash.jpg"),
  sp("Jellyfish", "joel-filipe-_AjqGGafofE-unsplash.jpg"))
jp << feed_post(jellyfish,
  "No bones, no brain, just pulse and light and the current carrying me exactly where I need to be.",
  sp("Jellyfish", "katarzyna-urbanek-kTP7Eyr66sQ-unsplash.jpg"),
  sp("Jellyfish", "masaaki-komori-6OAebnxQpJI-unsplash.jpg"))
jp << feed_post(jellyfish,
  "The deep has a quiet that land creatures never know. Here the silence has texture and weight and its own kind of song.",
  sp("Jellyfish", "mathilda-khoo-J_REyyXY14s-unsplash.jpg"),
  sp("Jellyfish", "nikolay-kovalenko-i8QdtA3dcNc-unsplash.jpg"))
jp << feed_post(jellyfish,
  "Watching the light filter down from the surface, thousands of feet above. Every beam is a reminder the sun exists even when you cannot see it.",
  sp("Jellyfish", "nikolay-kovalenko-_PN9fPOHiCk-unsplash.jpg"),
  sp("Jellyfish", "nikolay-kovalenko-rkrqdfLPP88-unsplash.jpg"))
jp << feed_post(jellyfish,
  "Sometimes being untethered is the most honest way to live. Let the current decide.",
  sp("Jellyfish", "praveen-thotagamuwa-jEqyV_rumuU-unsplash.jpg"),
  sp("Jellyfish", "tavis-beck-gRr64-OCKy0-unsplash.jpg"))
jp << feed_post(jellyfish,
  "Another night in the abyss. Not lonely. Never lonely. The ocean breathes and I breathe with it.",
  sp("Jellyfish", "tolga-ahmetler-1-N6zmu7CxY-unsplash.jpg"))

# ============================================================
# OCTOPUS — Otto Inkwell
# ============================================================
puts "Creating Octopus..."
octopus = make_user(
  email:    "otto@odinbook.com",
  name:     "Otto Inkwell",
  location: "Coral Cavern District",
  birthday: Date.new(2007, 2, 14)
)
avatar_post(octopus, sp("Octopus", "compagnons-IKXHeZw2XoY-unsplash.jpg"))
bg_post(octopus,     sp("Octopus", "diane-picchiottino-dW0gfo__uU8-unsplash.jpg"))

op = []
op << feed_post(octopus,
  "Changed my color seven times before breakfast. Not because I needed to. Just because I could.",
  sp("Octopus", "isabel-galvez-i54owgDjXeY-unsplash.jpg"),
  sp("Octopus", "kino-lIwepv6auAU-unsplash.jpg"))
op << feed_post(octopus,
  "Opened a jar today — purely for fun. There is a particular satisfaction in solving puzzles the ocean did not design for fingers.",
  sp("Octopus", "maximilian-schaffler-ZttSM8Zs1sw-unsplash.jpg"))
op << feed_post(octopus,
  "Each arm has its own mind and together we are thinking eight different things at once. This is normal. This is Wednesday.")
op << feed_post(octopus,
  "The reef is quieter than usual today. Something is moving through the water that has not been here before.")
op << feed_post(octopus,
  "Blending in is an art form. The best disguise is the one no one ever knows was there.")

# ============================================================
# TURTLE — Terry Shellsworth
# ============================================================
puts "Creating Turtle..."
turtle = make_user(
  email:    "terry@odinbook.com",
  name:     "Terry Shellsworth",
  location: "Ancient Shoreline",
  birthday: Date.new(1901, 4, 7)
)
avatar_post(turtle, sp("Turtle", "abner-abiu-castillo-diaz-N5ByCirHVqw-unsplash.jpg"))
bg_post(turtle,     sp("Turtle", "francesco-ungaro-GX81x7KTfIw-unsplash.jpg"))

trp = []
trp << feed_post(turtle,
  "Two hundred years of coastline, and this beach still surprises me. The ocean is never the same twice.",
  sp("Turtle", "francesco-ungaro-nlqqldluDBw-unsplash.jpg"),
  sp("Turtle", "josue-soto-v9zljzMw0S8-unsplash.jpg"))
trp << feed_post(turtle,
  "The young ones ask me why I move so slowly. I tell them: every surface has something to feel. Every moment has something to notice. Speed misses most of it.",
  sp("Turtle", "olga-ga-iRgbLpf50IE-unsplash.jpg"))
trp << feed_post(turtle,
  "Laid my eggs in the same spot my mother did, and her mother before her. Some things do not need to be changed.",
  sp("Turtle", "sercan-jenkins--rIps_UXSV4-unsplash.jpg"))
trp << feed_post(turtle,
  "Watched a ship pass overhead today. Enormous from below, gone in a moment. Everything that seems permanent is temporary if you live long enough.",
  sp("Turtle", "victor-ene-CmRp_0MG8f0-unsplash.jpg"))
trp << feed_post(turtle,
  "Deep breath. Long dive. The surface is always there when you need it.",
  sp("Turtle", "zoshua-colah-tB9Y9CvcB0s-unsplash.jpg"))

# ============================================================
# WHALES — Wally Deepson
# ============================================================
puts "Creating Whales..."
whales = make_user(
  email:    "wally@odinbook.com",
  name:     "Wally Deepson",
  location: "The Northern Feeding Grounds",
  birthday: Date.new(1975, 12, 1)
)
avatar_post(whales, sp("Whales", "cheryl-emerick-Yuw-C-DZN0Q-unsplash.jpg"))
bg_post(whales,     sp("Whales", "chinh-le-duc-8t9uyncwnHc-unsplash.jpg"))

wp = []
wp << feed_post(whales,
  "Sang across four hundred miles of open ocean today. Somewhere out there, someone answered.",
  sp("Whales", "chinh-le-duc-9YvSsGDZHmw-unsplash.jpg"),
  sp("Whales", "chinh-le-duc-P19iVmm7XUA-unsplash.jpg"))
wp << feed_post(whales,
  "Breached at sunrise just to feel the air and the light and the impossibility of being this large and still able to fly, even for a moment.",
  sp("Whales", "jonathan-hsu-PQZHHkXN18Y-unsplash.jpg"),
  sp("Whales", "oliver-tsappis-m3KT9kpfWdk-unsplash.jpg"))
wp << feed_post(whales,
  "The migration begins. We have been charting these routes for ten thousand years. The ocean knows our name.",
  sp("Whales", "rod-long-gUYYvPrnuHY-unsplash.jpg"))
wp << feed_post(whales,
  "Deep diving today, past the twilight zone into the midnight layer where the pressure could crush anything that does not know how to be still.",
  sp("Whales", "thomas-de-luze-m5v2MsxYzTw-unsplash.jpg"))
wp << feed_post(whales,
  "A pod reunion in the northern feeding grounds. The elders recognize each other by song. We always find our way back.",
  sp("Whales", "thomas-lipke-kkXDhAUnxYI-unsplash (1).jpg"),
  sp("Whales", "todd-cravens-lwACYK8ScmA-unsplash.jpg"))

# ============================================================
# FRIENDSHIPS (bidirectional — both sides have sent a request)
# ============================================================
puts "Creating friendships..."

befriend(bird,     deer)       # Nature neighbours
befriend(bird,     fox)        # Wild spirits
befriend(bird,     whales)     # Free travellers
befriend(cow,      dog)        # Farm companions
befriend(cow,      elephant)   # Gentle herbivores
befriend(deer,     dog)        # Forest meets park
befriend(deer,     turtle)     # Slow and serene living
befriend(dog,      fox)        # Pack instinct
befriend(elephant, turtle)     # Ancient wisdom club
befriend(elephant, whales)     # Giants of the world
befriend(jellyfish, octopus)   # Deep sea duo
befriend(jellyfish, whales)    # Ocean family
befriend(octopus,  turtle)     # Ocean floor neighbours

# ============================================================
# PENDING FRIEND REQUESTS (one direction only — awaiting response)
# ============================================================
puts "Creating pending friend requests..."

send_request(from: bird,    to: cow)       # Bird is curious about the calm life
send_request(from: cow,     to: jellyfish) # Cow wants to explore the ocean world
send_request(from: dog,     to: octopus)   # Dog wants to meet ocean creatures
send_request(from: fox,     to: turtle)    # Fox sent a request, Turtle has not responded
send_request(from: deer,    to: elephant)  # Deer admires the elephant's wisdom
send_request(from: octopus, to: cow)       # Octopus curious about land life
send_request(from: turtle,  to: bird)      # Turtle sent a request, Bird is away migrating

# ============================================================
# COMMENTS & REPLIES (friends interacting on each other's posts)
# ============================================================
puts "Creating comments..."

# --- Bird's posts ---
c = comment_on(author: deer,   post: bp[0], body: "From the forest floor your world looks like a dream. Must come see the canopy someday.")
r = reply_to(  author: bird,   comment: c,  body: "The valley between our worlds is the best part. See you at the overlook.")
    reply_to(  author: deer,   comment: r,  body: "I will bring the quiet. You bring the view. Fair trade.")
c = comment_on(author: fox,    post: bp[0], body: "I watch you sometimes from the ridge at dawn. Pure poetry in motion.")
r = reply_to(  author: bird,   comment: c,  body: "You are always the last thing I see before I climb. I appreciate it.")
r = reply_to(  author: fox,    comment: r,  body: "Two creatures of the early hour. We should compare notes one morning.")
    reply_to(  author: bird,   comment: r,  body: "Bring your nose, I will bring my eyes. Between us we will miss nothing.")
    comment_on(author: whales, post: bp[1], body: "A sliver of ocean from up there. That sliver is my entire world down here.")
c = comment_on(author: deer,   post: bp[2], body: "First flights. I remember my first steps on shaking legs. The terror and the joy were the same thing.")
r = reply_to(  author: bird,   comment: c,  body: "Exactly the same thing. The trick is to never wait for the fear to leave first.")
    reply_to(  author: deer,   comment: r,  body: "Wise words for the little ones. And for the rest of us too.")
    comment_on(author: fox,    post: bp[2], body: "Teaching is its own kind of flying. You are good at it.")
c = comment_on(author: whales, post: bp[3], body: "We should coordinate. Our migration routes might overlap somewhere over the Pacific.")
r = reply_to(  author: bird,   comment: c,  body: "Can you imagine — the sky meeting the sea at the same point? That would be extraordinary.")
r = reply_to(  author: whales, comment: r,  body: "I will sing when I reach the crossing. Listen for it.")
    reply_to(  author: bird,   comment: r,  body: "I will be listening. I always am.")
    comment_on(author: fox,    post: bp[4], body: "This energy is contagious. You always find the bright side of every weather.")

# --- Cow's posts ---
c = comment_on(author: dog,      post: cp[0], body: "Nothing beats the morning routine. Yours has clover, mine has a walk, but same energy entirely.")
r = reply_to(  author: cow,      comment: c,  body: "Come graze with me sometime. The north pasture is exceptional this season.")
    reply_to(  author: dog,      comment: r,  body: "I will be there. I promise not to chase anything. Mostly.")
c = comment_on(author: elephant, post: cp[0], body: "Peace in slow mornings. You remind me of the way the savanna feels at first light.")
r = reply_to(  author: cow,      comment: c,  body: "I have always imagined the savanna must be like the meadow, but grander and older.")
    reply_to(  author: elephant, comment: r,  body: "Grander, maybe. But the meadow has a softness the savanna never learned.")
    comment_on(author: dog,      post: cp[1], body: "Golden afternoons in the meadow. I would nap in that light for hours.")
c = comment_on(author: elephant, post: cp[2], body: "A perfect patch of clover near an old oak. The small things hold the whole world together.")
    reply_to(  author: cow,      comment: c,  body: "You always understand exactly what I mean. That is rare.")
    comment_on(author: dog,      post: cp[3], body: "The north pasture sunsets are the best. I have watched a few from the fence line.")
c = comment_on(author: dog,      post: cp[4], body: "Good company is the key ingredient to everything. Very glad we found each other.")
    reply_to(  author: cow,      comment: c,  body: "Slow grass and a good friend. That is the whole recipe, honestly.")

# --- Deer's posts ---
c = comment_on(author: bird,   post: dp[0], body: "I can see your forest from above and it looks exactly like it sounds — full of secrets.")
r = reply_to(  author: deer,   comment: c,  body: "Next time you fly over, I will be the one in the clearing waving up at you.")
    reply_to(  author: bird,   comment: r,  body: "I will dip a wing. That is how you will know it is me.")
c = comment_on(author: turtle, post: dp[0], body: "Forests have such a timeless quality. Some of those trees were saplings when I first walked through.")
r = reply_to(  author: deer,   comment: c,  body: "You have known these woods longer than the woods have known themselves. That amazes me.")
r = reply_to(  author: turtle, comment: r,  body: "Give it a century or two. You will start to see the shape of things.")
    reply_to(  author: deer,   comment: r,  body: "I will hold you to that. Meet me here in a hundred years.")
c = comment_on(author: dog,    post: dp[1], body: "A fawn! I would have chased it around the clearing three times and called it friendship.")
    reply_to(  author: deer,   comment: c,  body: "It would have loved that, honestly. The little ones adore you.")
    comment_on(author: bird,   post: dp[2], body: "Autumn arriving. I feel it in the wind before I see it in the leaves.")
c = comment_on(author: dog,    post: dp[3], body: "Running through open fields at dusk. We are the same creature in two different coats.")
    reply_to(  author: deer,   comment: c,  body: "We really are. Race you to the tree line sometime.")
    comment_on(author: turtle, post: dp[4], body: "Stillness is something I have practiced for a very long time. You are a natural.")

# --- Dog's posts ---
c = comment_on(author: cow, post: dop[0], body: "Twelve new smells! I count maybe forty in the whole meadow and revisit them daily. Very impressed.")
r = reply_to(  author: dog, comment: c,   body: "Trade you some meadow smells for some trail smells. Serious offer.")
    reply_to(  author: cow, comment: r,   body: "Deal. Though I warn you, mine are mostly clover and more clover.")
c = comment_on(author: fox, post: dop[0], body: "You and I should compare notes on eastern trail scents sometime. I have been cataloguing for years.")
r = reply_to(  author: dog, comment: c,   body: "Deal. Meet me at the elm by the creek at dusk.")
r = reply_to(  author: fox, comment: r,   body: "Dusk it is. Bring your enthusiasm, I will bring the precision.")
    reply_to(  author: dog, comment: r,   body: "Between the two of us we are basically one excellent tracker.")
c = comment_on(author: deer, post: dop[1], body: "Fetch as a philosophy. I think you might be onto something genuinely profound here.")
    reply_to(  author: dog,  comment: c,  body: "I have a lot of time to think between throws. The thinking adds up.")
    comment_on(author: fox,  post: dop[2], body: "Waiting as a kind of hope. I did not expect that from you, but I love it.")
c = comment_on(author: deer, post: dop[3], body: "Couch days are sacred. Even out here we have our version of the rainy day rest.")
    reply_to(  author: dog,  comment: c,  body: "The whole forest could learn something from a good couch day.")
    comment_on(author: cow,  post: dop[4], body: "The feeling when you come home after a long day in the pasture is exactly this.")

# --- Elephant's posts ---
c = comment_on(author: cow,      post: ep[0], body: "Thirty miles! I barely manage three before breakfast. You are an absolute inspiration.")
r = reply_to(  author: elephant, comment: c,  body: "Each mile is a story. The distance is never the point — the path is.")
    reply_to(  author: cow,      comment: r,  body: "I am going to remember that on my next slow walk to the far fence.")
c = comment_on(author: turtle,   post: ep[0], body: "Ancient paths are the most reliable ones. I have been following the same shoreline for decades.")
r = reply_to(  author: elephant, comment: c,  body: "The paths that carry the most memory are always the ones worth walking again.")
r = reply_to(  author: turtle,   comment: r,  body: "We are two of the few who still remember the old routes. That is a responsibility.")
    reply_to(  author: elephant, comment: r,  body: "Then we carry it together. The young ones will need it one day.")
c = comment_on(author: whales,   post: ep[0], body: "We feel the same about migration routes. Thousands of years of ocean memory in every dive.")
    reply_to(  author: elephant, comment: c,  body: "One day I would love to hear about the routes you carry. Your memory must be extraordinary.")
    comment_on(author: cow,      post: ep[1], body: "Old friends at the watering hole. That is the savanna version of the meadow gate gossip.")
c = comment_on(author: turtle,   post: ep[2], body: "A hundred years of memory in one place. I understand that feeling more than most.")
    reply_to(  author: elephant, comment: c,  body: "I knew you would. Few others could.")
    comment_on(author: whales,   post: ep[3], body: "Protecting the little ones is the oldest work there is. Land or ocean, it is the same.")
c = comment_on(author: cow,      post: ep[4], body: "Dust and distance and the wide open sky. You make the long road sound like a gift.")
r = reply_to(  author: elephant, comment: c,  body: "It is a gift. Most burdens are, if you carry them long enough.")
    reply_to(  author: whales,   comment: r,  body: "Freedom in migration and meaning in the journey home. You said it better than I ever could.")

# --- Fox's posts ---
c = comment_on(author: bird, post: fxp[0], body: "I was just waking up when you were already out there. I had no idea someone else claimed that hour.")
r = reply_to(  author: fox,  comment: c,   body: "The blue hour is big enough for two. Just stay out of my hunting line.")
    reply_to(  author: bird, comment: r,   body: "I will keep to the high branches. You keep to the shadows. Deal.")
c = comment_on(author: dog,  post: fxp[0], body: "You and your nights. I respect it completely but dawn is firmly my territory.")
r = reply_to(  author: fox,  comment: c,   body: "Dawn is just the blue hour that gave up and went bright. But I respect it too.")
    reply_to(  author: dog,  comment: r,   body: "That is the most fox sentence I have ever read.")
    comment_on(author: bird, post: fxp[1], body: "The forest is full of secrets if you know how to listen. You taught me that.")
c = comment_on(author: bird, post: fxp[2], body: "Dusk from above is all gold and long shadows. Your view from the ridge must be different but just as good.")
r = reply_to(  author: fox,  comment: c,   body: "From the ridge the whole world turns amber. You would absolutely love it.")
    reply_to(  author: bird, comment: r,   body: "Then I am coming up next dusk. Save me a spot.")
c = comment_on(author: dog,  post: fxp[3], body: "Three dead ends and a perfect path. Some days that ratio is even worse and still counts as a win.")
    reply_to(  author: fox,  comment: c,   body: "The dead ends are not failures. They are just the map filling in.")
    comment_on(author: dog,  post: fxp[4], body: "The night has a vocabulary the day cannot speak. I am slowly learning a few words from you.")

# --- Jellyfish's posts ---
c = comment_on(author: octopus,  post: jp[0], body: "The thermocline is incredible. I visit it when the mood strikes and the pressure cooperates.")
r = reply_to(  author: jellyfish, comment: c, body: "We should drift that layer together sometime. It is completely different with company.")
    reply_to(  author: octopus,  comment: r, body: "I will meet you at the cold edge. Bring the light, I will bring the curiosity.")
c = comment_on(author: whales,   post: jp[0], body: "We pass through that layer on every deep dive. It always feels like crossing a border into another world.")
r = reply_to(  author: jellyfish, comment: c, body: "Yes — a border between the known world and the one below it. Exactly right.")
r = reply_to(  author: whales,   comment: r, body: "I will think of you every time I cross it now.")
    reply_to(  author: jellyfish, comment: r, body: "And I will feel the water move when you pass. That is how I will know.")
    comment_on(author: octopus,  post: jp[1], body: "No bones and still one of the most interesting people in the ocean. Genuinely inspiring.")
c = comment_on(author: whales,   post: jp[2], body: "The silence of the deep has its own song. You are one of the few who can hear it.")
    reply_to(  author: jellyfish, comment: c, body: "You hear it too. That is why your songs reach so far down.")
    comment_on(author: octopus,  post: jp[3], body: "Light from thousands of feet above. I forget the sun some days. Thank you for the reminder.")
    comment_on(author: whales,   post: jp[4], body: "Let the current decide. This is a whole philosophy. Going to think about this for a while.")
c = comment_on(author: octopus,  post: jp[5], body: "Never lonely in the abyss. I understand that completely. The dark is good company once you know it.")
    reply_to(  author: jellyfish, comment: c, body: "It really is. The two of us were built for it.")

# --- Octopus's posts ---
c = comment_on(author: jellyfish, post: op[0], body: "The color changes are extraordinary. I glow and that is about all I have by comparison.")
r = reply_to(  author: octopus,  comment: c,  body: "Do not undersell the glow. It is the most beautiful thing in the deep.")
    reply_to(  author: jellyfish, comment: r, body: "Coming from you, that means everything.")
c = comment_on(author: turtle,   post: op[1], body: "The jar trick again. The ones who solve puzzles just to see if they can are always the most interesting.")
r = reply_to(  author: octopus,  comment: c,  body: "You have been paying attention. I am genuinely flattered.")
r = reply_to(  author: turtle,   comment: r,  body: "I have had a long time to learn who is worth paying attention to.")
    reply_to(  author: octopus,  comment: r,  body: "Two hundred years of judgment and I made the list. I will take that.")
    comment_on(author: jellyfish, post: op[2], body: "Eight minds thinking eight things at once and here you are making it look completely effortless.")
c = comment_on(author: turtle,   post: op[3], body: "Something new moving through the reef. Trust that feeling. The water tells the truth.")
    reply_to(  author: octopus,  comment: c,  body: "I always trust it. It has never once been wrong.")
    comment_on(author: jellyfish, post: op[4], body: "The best disguise is the one no one knew was there. I drift in plain sight, you vanish in it. Opposites.")

# --- Turtle's posts ---
c = comment_on(author: octopus,  post: trp[0], body: "Two hundred years of coastline and it still surprises you. That is the most hopeful thing I have read.")
    reply_to(  author: turtle,   comment: c,   body: "Surprise is the reward for paying attention. It never runs out.")
c = comment_on(author: deer,     post: trp[1], body: "This is something I try to practice. You live it naturally. There is a lesson in that.")
r = reply_to(  author: turtle,   comment: c,   body: "A hundred and twenty years of practice. You will get there.")
    reply_to(  author: deer,     comment: r,   body: "I will check back in a century. Save my spot by the stream.")
c = comment_on(author: elephant, post: trp[1], body: "Patience is the oldest wisdom. Those who hurry past the moment miss the moment entirely.")
r = reply_to(  author: turtle,   comment: c,   body: "I have been saying this for centuries. It is good to finally have someone understand.")
r = reply_to(  author: elephant, comment: r,   body: "The slow ones inherit the truth. The fast ones just inherit the next thing.")
    reply_to(  author: turtle,   comment: r,   body: "Write that one down. I am keeping it.")
    comment_on(author: octopus,  post: trp[1], body: "Eight arms doing eight things at once and I still feel like I am rushing. You are a role model.")
c = comment_on(author: deer,     post: trp[2], body: "The same spot your mother used. There is something sacred about that continuity.")
    reply_to(  author: turtle,   comment: c,   body: "Sacred is the right word. Some things you do not improve. You just continue them.")
    comment_on(author: elephant, post: trp[3], body: "Everything permanent is temporary if you live long enough. You and I both know that better than anyone.")
c = comment_on(author: octopus,  post: trp[4], body: "Deep breath, long dive. The surface always waiting. I needed to read that today.")
    reply_to(  author: turtle,   comment: c,   body: "Then I am glad I surfaced long enough to write it.")

# --- Whales's posts ---
c = comment_on(author: jellyfish, post: wp[0], body: "I hear the singing sometimes when I drift into the deep water. It is the most beautiful sound in the ocean.")
r = reply_to(  author: whales,   comment: c,   body: "I hope one of those songs reached you. We put everything into them.")
    reply_to(  author: jellyfish, comment: r,   body: "It reached me. It always reaches me. That is the point of it, I think.")
c = comment_on(author: bird,     post: wp[0], body: "Four hundred miles of song. I can cover that distance in a day but never with that kind of range.")
r = reply_to(  author: whales,   comment: c,   body: "And you cover it with wings. We are both free in our own way.")
    reply_to(  author: bird,     comment: r,   body: "Free in our own way. I am going to carry that one with me.")
c = comment_on(author: elephant, post: wp[0], body: "Forty years ago I heard your grandmother singing from across the savanna. The voice carries in the family.")
r = reply_to(  author: whales,   comment: c,   body: "You knew her song? That means more than you know. We carry the same history.")
r = reply_to(  author: elephant, comment: r,   body: "Her song crossed the whole basin. I never forgot it. Yours has the same shape.")
    reply_to(  author: whales,   comment: r,   body: "Then she is still singing, in a way. Thank you for telling me that.")
    comment_on(author: jellyfish, post: wp[1], body: "Enormous and still able to fly for a moment. This is the most majestic thing I have ever read.")
c = comment_on(author: bird,     post: wp[2], body: "Ten thousand years of routes. My flock has its own version of that. We are not so different.")
    reply_to(  author: whales,   comment: c,   body: "Not so different at all. Sky and sea, both just following the old maps.")
    comment_on(author: jellyfish, post: wp[3], body: "The midnight layer is my whole neighbourhood. Come visit properly sometime, not just passing through.")
    comment_on(author: elephant, post: wp[4], body: "We always find our way back. The family always knows each other. This is true for us too.")

puts "Odinbook is ready. 10 accounts, #{Post.count} posts, #{Comment.count} comments, #{FriendRequest.count} friend connections."
