class Post
  include HyperMapper::Document

  key :id
  attribute :title
  attribute :content

  embedded_in :user
end
