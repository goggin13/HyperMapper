require 'hyper_mapper'

class Tag
  include HyperMapper::Document

  attr_accessible :name

  autogenerate_id
  attribute :name
  
  has_and_belongs_to_many :posts, through: :post_tags
end
