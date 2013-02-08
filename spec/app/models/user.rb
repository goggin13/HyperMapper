
class User
  include HyperMapper::Document

  attribute :username, key: true
  attribute :email

end
