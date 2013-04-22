class Article
  include HyperMapper::Document
  
  attr_accessible :id, :title, :user_username
  
  autogenerate_id
  attribute :title
  attribute :user_username
  
  validates :title, presence: true
  
  belongs_to :user
  has_and_belongs_to_many :tags, through: :article_tags
end

