
class User
  include Mongoid::Document
  
  attr_accessible :username, :bio, :_id

  field :username
  field :bio
  
  embeds_many :posts
end