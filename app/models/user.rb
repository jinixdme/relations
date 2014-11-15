class User < ActiveRecord::Base
  has_one :mother, class_name: 'User', foreign_key: 'mother_id'
  
  has_many :playlists
  has_many :likes, :through => :playlists
  has_many :videos, :through => :likes
end
