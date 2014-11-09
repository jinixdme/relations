class Playlist < ActiveRecord::Base
  belongs_to :user
  has_many :likes
  has_many :videos, :through => :likes
end
