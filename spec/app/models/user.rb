
class User
  include HyperMapper::Document

  attribute :username, key: true
  attribute :email
  
  embeds_many :posts
  has_many :articles
end
