require 'hyper_mapper'

class PostTag
  include HyperMapper::Document

  autogenerate_id
  attribute :tag_id
  attribute :post_id

end
