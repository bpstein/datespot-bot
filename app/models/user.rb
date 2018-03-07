class User < ActiveRecord::Base
  validates :fb_id, :full_name, presence: true

  def first_name
    full_name.split(" ").first 
  end
end