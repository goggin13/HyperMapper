
class User
  include HyperMapper::Document
  
  attr_accessible :username, :email, :posts
  
  attribute :username, key: true
  attribute :email
  
  embeds_many :posts
  has_many :articles

end
