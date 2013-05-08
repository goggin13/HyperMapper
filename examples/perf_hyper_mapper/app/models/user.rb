require 'hyper_mapper'

class User
  include HyperMapper::Document
  
  attr_accessible :username, :bio
  
  key :_id, autogenerate: true
  attribute :username
  attribute :bio
  
  embeds_many :posts
end