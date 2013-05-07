require 'hyper_mapper'

class HyperUser
  include HyperMapper::Document
  
  attr_accessible :username, :bio
  
  autogenerate_id
  attribute :username
  attribute :bio
  
  embeds_many :hyper_posts
end