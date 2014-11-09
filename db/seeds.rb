# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# $ rake db:drop db:create db:migrate db:seed

# Self-referential one-to-one relationship:
john = User.create(first_name: 'John')
heidi = User.create(first_name: 'Heidi')
john.mother = heidi
puts john.mother.first_name
#=> Heidi

# Join model many-to-many relationship:
cat    = Video.create(title: 'Cat', engine: 'youtube', duration: 90)
dog    = Video.create(title: 'Dog', engine: 'youtube', duration: 120)
banana = Video.create(title: 'Banana', engine: 'vimeo', duration: 140)
apple  = Video.create(title: 'Apple', engine: 'dailymotion', duration: 240)
orange = Video.create(title: 'Orange', engine: 'dailymotion', duration: 30)

playlist = Playlist.create(name: 'Animals', user: john)
playlist.likes << Like.create(video: cat)
playlist.likes << Like.create(video: dog)
puts playlist.videos.count
#=> 2

playlist = Playlist.create(name: 'Fruits', user: john)
playlist.likes << Like.create(video: banana)
playlist.likes << Like.create(video: apple)
playlist.likes << Like.create(video: orange)
puts playlist.videos.count
#=> 3

john.likes.each { |like| puts like.video.title } 
#=> Cat
#   Dog
#   Banana
#   Apple
#   Orange
