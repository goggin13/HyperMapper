require 'hyper_mapper'

class Post
  include HyperMapper::Document

  key :id, autogenerate: true
  attribute :title
  attribute :content

  validates_presence_of :title
  validates_presence_of :content

  embedded_in :user
  has_and_belongs_to_many :tags, through: :post_tags
end

