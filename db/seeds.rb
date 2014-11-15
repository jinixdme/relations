# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# $ rake db:setup

# Self-referential one-to-one relationship:
john = User.create(first_name: 'John')
heidi = User.create(first_name: 'Heidi')

john.mother = heidi

puts john.mother.first_name
#=> Heidi

# Join model many-to-many relationship:
animals = Video.create([
  {title: 'Cat', engine: 'youtube', duration: 90},
  {title: 'Dog', engine: 'youtube', duration: 120}])

playlist = Playlist.create(name: 'Animals', user: john)

playlist.likes << animals.map{|animal| Like.create(video: animal)}

puts playlist.videos.count
#=> 2

fruits = Video.create([
  {title: 'Banana', engine: 'vimeo', duration: 140},
  {title: 'Apple', engine: 'dailymotion', duration: 240},
  {title: 'Orange', engine: 'dailymotion', duration: 30}])

playlist = Playlist.create(name: 'Fruits', user: john)

playlist.likes << fruits.map{|fruit| Like.create(video: fruit)}

puts playlist.videos.count
#=> 3

john.likes.each{|like| puts like.video.title} 
#=> Cat
#=> Dog
#=> Banana
#=> Apple
#=> Orange

john.videos.sort(:title).each{|video| 
  puts Rainbow("#{video.title}").yellow + " from #{video.engine.titleize} has a duration of #{video.duration} seconds"}
puts ""

john.videos.sort(:engine).each{|video| 
  puts Rainbow("#{video.engine.titleize}").yellow + " #{video.title} has a duration of #{video.duration} seconds"}
puts ""

john.videos.sort(:duration).each{|video| 
  puts Rainbow("#{video.duration}").yellow + " seconds is the duration of #{video.title} from #{video.engine.titleize}"}
puts ""

#=> Apple from Dailymotion has a duration of 240 seconds
#=> Banana from Vimeo has a duration of 140 seconds
#=> Cat from Youtube has a duration of 90 seconds
#=> Dog from Youtube has a duration of 120 seconds
#=> Orange from Dailymotion has a duration of 30 seconds

#=> Dailymotion Apple has a duration of 240 seconds
#=> Dailymotion Orange has a duration of 30 seconds
#=> Vimeo Banana has a duration of 140 seconds
#=> Youtube Cat has a duration of 90 seconds
#=> Youtube Dog has a duration of 120 seconds

#=> 30 seconds is the duration of Orange from Dailymotion
#=> 90 seconds is the duration of Cat from Youtube
#=> 120 seconds is the duration of Dog from Youtube
#=> 140 seconds is the duration of Banana from Vimeo
#=> 240 seconds is the duration of Apple from Dailymotion
