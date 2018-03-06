class User < ActiveRecord::Base
  validates :fb_id, :full_name, presence: true
end