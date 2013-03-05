class Article
  include HyperMapper::Document
  key :id, autogenerate: true
  attribute :title
end

