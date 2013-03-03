require 'hyper_mapper'

class User
  include HyperMapper::Document

  key :username
  attribute :first
  attribute :last

  embeds_many :posts

  def self.all
    []
  end

end
