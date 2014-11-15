# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# $ rake db:setup

puts "Self-referential one-to-one relationship:"
john = User.create(first_name: 'John')
heidi = User.create(first_name: 'Heidi')

john.mother = heidi

puts john.mother.first_name
puts ""
#=> Heidi

puts "Join model many-to-many relationship:"
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
puts ""
#=> Cat
#=> Dog
#=> Banana
#=> Apple
#=> Orange

puts "Order a has_many through association:"
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

john.videos.order(:title).each{|video| 
  puts Rainbow("#{video.title}").yellow + " from #{video.engine.titleize} has a duration of #{video.duration} seconds"}
puts ""
#=> Apple from Dailymotion has a duration of 240 seconds
#=> Banana from Vimeo has a duration of 140 seconds
#=> Cat from Youtube has a duration of 90 seconds
#=> Dog from Youtube has a duration of 120 seconds
#=> Orange from Dailymotion has a duration of 30 seconds

puts "Combined scope conditions:"
john.videos.duration_min(100).sort(:engine).each{|video| 
  puts Rainbow("#{video.engine.titleize}").yellow + " video #{video.title} has a duration of " + Rainbow("#{video.duration}").yellow + " seconds"}
puts ""
#=> Dailymotion Apple has a duration of 240 seconds
#=> Vimeo Banana has a duration of 140 seconds
#=> Youtube Dog has a duration of 120 seconds

puts "Merging scopes with joins:"
%w[Animals Fruits].each do |name|
  john.videos.list(name).each{|video| 
  puts "Playlist " + Rainbow("#{video.playlist.first.name}").yellow + " has video " + Rainbow("#{video.title}").yellow + " from #{video.engine.titleize}"}
end
puts ""
#=> Playlist Animals has video Cat from Youtube
#=> Playlist Animals has video Dog from Youtube
#=> Playlist Fruits has video Banana from Vimeo
#=> Playlist Fruits has video Apple from Dailymotion
#=> Playlist Fruits has video Orange from Dailymotion

puts "Merging scopes with joins:"
puts Video.vimeo.count
puts john.playlists.vimeo.first.videos.vimeo.first.title
#=> 1
#=> Banana
