class Tag
  include HyperMapper::Document
  key :name
  has_and_belongs_to_many :posts, through: :post_tags
end
