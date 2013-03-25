
class UserWithTimestamp 
  include HyperMapper::Document

  attribute :username, key: true
  attribute :email

  timestamps
end
