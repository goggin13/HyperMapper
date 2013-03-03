require 'hyper_mapper'

class Post
  include HyperMapper::Document

  key :id, autogenerate: true
  attribute :title
  attribute :content

  embedded_in :user
  
end

