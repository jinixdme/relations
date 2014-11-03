class User < ActiveRecord::Base
  has_one :mother, class_name: "User", foreign_key: 'mother_id'
end
