
class User
  include HyperMapper::Document

  key :username
  attribute :first
  attribute :last
  attribute :phone, :type => :int
  attribute :hobbies, :type => :string_set
  attribute :lucky_numbers, :type => :integer_set
  attribute :likes, :type => :map, 
                    :keys => :string, 
                    :values => :integer

end
