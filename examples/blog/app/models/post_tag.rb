
class ArticleTag
  include HyperMapper::Document

  autogenerate_id
  attribute :article_id
  attribute :tag_name

end
