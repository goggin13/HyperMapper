
class ArticleTag
  include HyperMapper::Document
  
  attr_accessible :article_id, :tag_name
  
  autogenerate_id
  attribute :article_id
  attribute :tag_name

end
