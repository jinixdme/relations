# Relations

**Relations is a Active Record queries collection based on Rails 4 and Ruby 2**

The magic happens within the migrations, the models and db/seed.rb.

To test the examples just run:

```
$ rake db:setup
```

## Self-referential one-to-one relationship
Everybody has one mother. At most.

```
$ rails g model user first_name:string mother_id:integer
$ rake db:migrate
```

**User model**

```ruby
has_one :mother, class_name: 'User', foreign_key: 'mother_id'
```

**db/seed**

```ruby
john = User.create(first_name: 'John')
heidi = User.create(first_name: 'Heidi')

john.mother = heidi

puts john.mother.first_name
```

```
=> Heidi
```

## Join model many-to-many relationship
A user wants to add all videos he likes to a playlist.

```
$ rails g model video title:string engine:string duration:integer
$ rails g model playlist name:string user_id:integer published:boolean
$ rails g model like video_id:integer playlist_id:integer
$ rake db:migrate
```

**Playlist model**

```ruby
belongs_to :user
has_many :likes
has_many :videos, :through => :likes
```

**User model**

```ruby
has_many :playlists
has_many :likes, :through => :playlists
```

**Like model**

```ruby
belongs_to :video
belongs_to :playlist
```

**db/seed**

```ruby
animals = Video.create([
  {title: 'Cat', engine: 'youtube', duration: 90},
  {title: 'Dog', engine: 'youtube', duration: 120}])

playlist = Playlist.create(name: 'Animals', user: john)

playlist.likes << animals.map{|animal| Like.create(video: animal)}

puts playlist.videos.count
```
```
=> 2
```

```ruby
fruits = Video.create([
  {title: 'Banana', engine: 'vimeo', duration: 140},
  {title: 'Apple', engine: 'dailymotion', duration: 240},
  {title: 'Orange', engine: 'dailymotion', duration: 30}])

playlist = Playlist.create(name: 'Fruits', user: john)

playlist.likes << fruits.map{|fruit| Like.create(video: fruit)}
```
```
=> 3
```

```ruby
john.likes.each{|like| puts like.video.title}
```

```
=> Cat
=> Dog
=> Banana
=> Apple
=> Orange
```

Inspired by [Clipflakes](http://blog.clipflakes.tv/2011/05/26/relaunch-der-website/)' video search engine and playlist creation.


##Order a has_many through association
Now we want a sorted list of all videos John likes. The list has to be sorted by a given video attribute, e.g. the name of the engine or the duration. Instead of iterate through all Like's we want the video list through a has_many through association. Example:

```ruby
videos = john.videos.sort(:engine)
```

**User model**

```ruby
has_many :videos, :through => :likes
```

**Video model**

```ruby
scope :sort, ->(column) { order column }
```

Videos sorted by title, engine and duration:


```ruby
john.videos.sort(:title).each{|video| 
  puts Rainbow("#{video.title}").yellow + " from #{video.engine.titleize} has a duration of #{video.duration} seconds"}
puts ""

john.videos.sort(:engine).each{|video| 
  puts Rainbow("#{video.engine.titleize}").yellow + "'s #{video.title} has a duration of #{video.duration} seconds"}
puts ""

john.videos.sort(:duration).each{|video| 
  puts Rainbow("#{video.duration}").yellow + " seconds is the duration of #{video.title} from #{video.engine.titleize}"}
puts ""
```

```
=> Apple from Dailymotion has a duration of 240 seconds
=> Banana from Vimeo has a duration of 140 seconds
=> Cat from Youtube has a duration of 90 seconds
=> Dog from Youtube has a duration of 120 seconds
=> Orange from Dailymotion has a duration of 30 seconds

=> Dailymotion Apple has a duration of 240 seconds
=> Dailymotion Orange has a duration of 30 seconds
=> Vimeo Banana has a duration of 140 seconds
=> Youtube Cat has a duration of 90 seconds
=> Youtube Dog has a duration of 120 seconds

=> 30 seconds is the duration of Orange from Dailymotion
=> 90 seconds is the duration of Cat from Youtube
=> 120 seconds is the duration of Dog from Youtube
=> 140 seconds is the duration of Banana from Vimeo
=> 240 seconds is the duration of Apple from Dailymotion
```

Inspired by the article [Sorting and Reordering Has Many Through Associations With the ActsAsList Gem](http://easyactiverecord.com/blog/2014/11/11/sorting-and-reordering-lists-with-the-actsaslist-gem/).