class Post
  include HyperMapper::Document
  
  attr_accessible :title, :id
  
  autogenerate_id
  attribute :title
  
  embedded_in :user
end
