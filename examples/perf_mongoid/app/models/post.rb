
class Post
  include Mongoid::Document
  
  attr_accessible :title, :content, :_id
  
  field :title
  field :content
  
  embedded_in :user
end