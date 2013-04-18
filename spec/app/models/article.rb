class Article
  include HyperMapper::Document
  
  attr_accessible :id, :title, :user_id
  
  key :id, autogenerate: true
  attribute :title
  attribute :user_id

  belongs_to :user
  has_and_belongs_to_many :tags, through: :article_tags
end

