# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Self-referential one-to-one relation:
son = User.create(first_name: 'John')
mother = User.create(first_name: 'Heidi')
son.mother = mother
puts son.mother.first_name
#=> Heidi
