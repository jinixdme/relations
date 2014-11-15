class Video < ActiveRecord::Base
  has_many :likes
  has_many :playlist, :through => :likes

  scope :sort, ->(column) { order column }
  scope :duration_min, ->(seconds) { where(duration: seconds.to_i..Float::INFINITY) }
  scope :list, ->(name) { joins(:playlist).merge( Playlist.where(name: name) )}
  scope :vimeo, -> { where(engine: 'vimeo') }
end
