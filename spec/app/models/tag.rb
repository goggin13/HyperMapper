class Tag
  include HyperMapper::Document
  attr_accessible :name
  key :name
  has_and_belongs_to_many :articles, through: :article_tags
end
