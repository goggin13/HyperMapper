class Post
  include HyperMapper::Document
  
  attr_accessible :title, :id
  
  autogenerate_id
  attribute :title
  
  validates :title, presence: true
  
  embedded_in :user
end
