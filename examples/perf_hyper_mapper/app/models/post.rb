require 'hyper_mapper'

class Post
  include HyperMapper::Document
  
  attr_accessible :title, :content, :user_id, :tag_string, :_id
  
  key :_id, autogenerate: true
  attribute :title
  attribute :content
  
  embedded_in :user
end