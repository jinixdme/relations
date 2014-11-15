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
