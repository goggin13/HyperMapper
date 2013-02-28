require 'hyper_mapper'

class User
  include HyperMapper::Document

  key :username
  attribute :first
  attribute :last

  embeds_many :posts

  def to_key
    [username]
  end

  def persisted?
    false
  end

  def model_name
    'User'
  end

  def self.all
    []
  end

end
