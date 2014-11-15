class Video < ActiveRecord::Base
  scope :sort, ->(column) { order column }
  scope :duration_min, ->(seconds) { where(duration: seconds.to_i..Float::INFINITY) }
end
