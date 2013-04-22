
class User
  include HyperMapper::Document
  
  attr_accessible :username, :email, :posts
  
  key :username
  attribute :email
  
  embeds_many :posts
  has_many :articles

end
