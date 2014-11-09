# Relations

**Relations is a Active Record queries collection based on Rails 4.1.6 and Ruby 2.1.4.**

The magic happens within the migrations, the models and db/seed.rb.

To test the examples just run:

> $ rake db:drop db:create db:migrate db:seed

## Self-referential one-to-one relationship
Everybody has one mother. At most.

> $ rails g model user first_name:string mother_id:integer

**User model**

> has_one :mother, class_name: "User", foreign_key: 'mother_id'

**db/seed**

> john = User.create(first_name: 'John')

> heidi = User.create(first_name: 'Heidi')

> john.mother = heidi

> puts john.mother.first_name

> => Heidi

## Join model many-to-many relationship
A user wants to add all videos he likes to a playlist.

> $ rails g model video title:string engine:string duration:integer

> $ rails g model playlist name:string user_id:integer published:boolean

> $ rails g model like video_id:integer playlist_id:integer

> $ rake db:migrate

**Playlist model**

> belongs_to :user

> has_many :likes

> has_many :videos, :through => :likes

**User model**

> has_many :playlists

> has_many :likes, :through => :playlists

**Like model**

> belongs_to :video

> belongs_to :playlist

**db/seed**

> cat    = Video.create(title: 'Cat', engine: 'youtube', duration: 90)

> dog    = Video.create(title: 'Dog', engine: 'youtube', duration: 120)

> banana = Video.create(title: 'Banana', engine: 'vimeo', duration: 140)

> apple  = Video.create(title: 'Apple', engine: 'dailymotion', duration: 240)

> orange = Video.create(title: 'Orange', engine: 'dailymotion', duration: 30)

> playlist = Playlist.create(name: 'Animals', user: john)

> playlist.likes << Like.create(video: cat)

> playlist.likes << Like.create(video: dog)

> puts playlist.videos.count

> => 2

> playlist = Playlist.create(name: 'Fruits', user: john)

> playlist.likes << Like.create(video: banana)

> playlist.likes << Like.create(video: apple)

> playlist.likes << Like.create(video: orange)

> puts playlist.videos.count

> => 3

> john.likes.each { |like| puts like.video.title } 

> => Cat

>    Dog

>    Banana

>    Apple

>    Orange
