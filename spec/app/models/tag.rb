class Tag
  include HyperMapper::Document
  attr_accessible :name, :description
  key :name
  attribute :description
  has_and_belongs_to_many :articles, through: :article_tags
end
