# Relations

**Relations is a Active Record queries collection based on Rails 4.1.6 and Ruby 2.1.3.**

The magic happens within the migrations, the models and db/seed.rb.

To test the examples just run:

'' $ rake db:drop db:create db:migrate db:seed

These are the app creation steps (I assume that you’ve already installed RVM, Ruby 2.1.3 and git):

'' $ mkdir relations
'' $ cd relations
'' $ gem update --system
'' $ rvm use ruby-2.1.3@relations --create
'' $ gem install rails -v='4.1.6'
'' $ rails new .
'' $ git init

## Self-referential one-to-one relationship
Everybody has one mother. At most.

'' $ rails g scaffold User first_name:string mother_id:integer

**User model**

'' has_one :mother, class_name: "User", foreign_key: 'mother_id'

**db/seed**

'' john = User.create(first_name: 'John')
'' heidi = User.create(first_name: 'Heidi')
'' john.mother = heidi
'' puts john.mother.first_name
'' #=> Heidi
