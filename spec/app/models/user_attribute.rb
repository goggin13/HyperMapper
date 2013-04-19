
class UserAttribute
  include HyperMapper::Document
  
  attr_accessible :username, :email
  
  key :username

  attribute :test_string
  attribute :test_int, type: :int
  attribute :test_float, type: :float
  attribute :test_datetime, type: :datetime

end
