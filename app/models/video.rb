class Video < ActiveRecord::Base
  scope :sort, ->(column) { order column }
end
