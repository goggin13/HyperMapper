require 'hyper_mapper'

class PostTag
  include HyperMapper::Document

  attr_accessible :tag_id, :post_id

  autogenerate_id
  attribute :tag_id
  attribute :post_id

end
