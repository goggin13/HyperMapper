
class MongoidPost
  include Mongoid::Document

  field :title
  field :content
  
  embedded_in :mongoid_user
end