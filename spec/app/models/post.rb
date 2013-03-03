class Post
  include HyperMapper::Document
  attribute :title
  attribute :id, key: true, autogenerate: true
  
  embedded_in :user
end
