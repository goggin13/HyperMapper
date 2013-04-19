
class UserWithTimestamp 
  include HyperMapper::Document
  
  attr_accessible :username, :email
  
  key :username
  attribute :email

  timestamps
end
