require 'hyper_mapper'

class HyperPost
  include HyperMapper::Document
  
  attr_accessible :title, :content, :user_id, :tag_string
  
  autogenerate_id
  attribute :title
  attribute :content
  timestamps
  
  embedded_in :hyper_user
end