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

puts "John's mother is " + Rainbow("#{john.mother.first_name}").yellow
puts ""

puts "Join model many-to-many relationship:"
animals = Video.create([
  {title: 'Cat', engine: 'youtube', duration: 90},
  {title: 'Dog', engine: 'youtube', duration: 120}])

playlist = john.playlists.create name: 'Animals'
playlist.likes << animals.map{|animal| Like.create video: animal}

puts playlist.videos.count

fruits = Video.create([
  {title: 'Banana', engine: 'vimeo', duration: 140},
  {title: 'Apple', engine: 'dailymotion', duration: 240},
  {title: 'Orange', engine: 'dailymotion', duration: 30}])

playlist = john.playlists.create name: 'Fruits'
playlist.likes << fruits.map{|fruit| Like.create video: fruit}

puts playlist.videos.count

john.likes.each{|like| puts like.video.title} 
puts ""

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

john.videos.order(:title).each{|video| 
  puts Rainbow("#{video.title}").yellow + " from #{video.engine.titleize} has a duration of #{video.duration} seconds"}
puts ""

puts "Combined scope conditions:"
john.videos.duration_min(100).sort(:engine).each{|video| 
  puts Rainbow("#{video.engine.titleize}").yellow + " video #{video.title} has a duration of " + Rainbow("#{video.duration}").yellow + " seconds"}
puts ""

puts "Merging scopes with joins:"
%w[Animals Fruits].each do |name|
  # use of association collection average method
  puts "Playlist " + Rainbow("#{name}").yellow + " has an average duration of " + Rainbow("#{john.videos.list(name).average(:duration).to_i}").yellow + " seconds"
  john.videos.list(name).each{|video| 
  puts "Playlist " + Rainbow("#{name}").yellow + " has video " + Rainbow("#{video.title}").yellow + " from #{video.engine.titleize}"}
end
puts ""

puts "Merging scopes with joins:"
puts Video.vimeo.count
puts Rainbow("#{john.playlists.vimeo.first.videos.vimeo.first.title}").yellow