require 'hyper_mapper'

class User
  include HyperMapper::Document

  key :username
  attribute :first
  attribute :last
  attribute :email
  timestamps 

  validates_presence_of :email

  embeds_many :posts
end
