
class MongoidUser
  include Mongoid::Document
  
  attr_accessible :username, :bio

  field :username
  field :bio  
  
  embeds_many :mongoid_posts
end