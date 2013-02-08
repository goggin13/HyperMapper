
class User
  include HyperMapper::Document

  key :username
  attribute :email

end