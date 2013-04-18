
class UserWithTimestamp 
  include HyperMapper::Document
  
  attr_accessible :username, :email
  
  attribute :username, key: true
  attribute :email

  timestamps
end
