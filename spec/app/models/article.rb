class Article
  include HyperMapper::Document
  key :id, autogenerate: true
  attribute :title
  attribute :user_id

  belongs_to :user
end

